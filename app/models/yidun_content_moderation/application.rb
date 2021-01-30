# frozen_string_literal: true

module YidunContentModeration
  class Application < ApplicationRecord
    # constants

    # concerns

    # attr related macros

    # association macros
    has_many :tasks, class_name: "YidunContentModeration::Task", dependent: :destroy

    # validation macros

    # callbacks

    # other macros

    # scopes

    # class methods
    # 只关联一个易盾应用时可以用此方法获取application记录
    def self.instance
      @@instance ||= first
    end

    # instance methods
    def client
      @client ||= Client.new(secret_id: secret_id, secret_key: secret_key)
    end

    def text_check(content:)
      client.text_check(content: content, business_id: text_check_business_id)
    end

    def text_batch_check(texts:)
      client.text_batch_check(
        texts: texts.map { |text| { dataId: SecureRandom.uuid, content: text[:content] } }.to_json,
        business_id: text_check_business_id
      )
    end

    def user_text_check(content:)
      client.text_check(content: content, business_id: user_text_check_business_id)
    end

    def image_check(images:)
      client.image_check(images: images.to_json, business_id: image_check_business_id)
    end

    def image_async_check!(images:)
      images = images.select { |image| tasks.where(name: images.map { |image| image[:data] }).map(&:name).exclude?(image[:data]) }

      return if images.empty?

      resp = client.image_async_check(images: images.to_json, business_id: image_check_business_id)

      raise resp.msg unless resp.success?

      transaction do
        resp["result"]["checkImages"].each do |data|
          tasks.create!(name: data["name"], yidun_task_id: data["taskId"], check_type: :image)
        end
      end

      resp
    end

    def image_async_result(task_ids:)
      client.image_async_result(task_ids: task_ids.join(","), business_id: image_check_business_id)
    end

    def user_image_check(images:)
      client.image_check(images: images.to_json, business_id: user_image_check_business_id)
    end

    def audio_submit!(url:, callback: nil)
      return if tasks.exists?(name: url)

      resp = client.audio_submit(url: url, business_id: audio_check_business_id, callback: callback)

      raise resp.msg unless resp.success?

      tasks.create!(name: url, yidun_task_id: resp["result"]["taskId"], check_type: :audio) if resp.success?

      resp
    end

    def video_submit!(url:, callback: nil)
      return if tasks.exists?(name: url)

      resp = client.video_submit(url: url, business_id: video_check_business_id, callback: callback)

      raise resp.msg unless resp.success?

      tasks.create!(name: url, yidun_task_id: resp["result"]["taskId"], check_type: :video) if resp.success?

      resp
    end

    def video_callback_results!
      resp = client.video_callback_results(business_id: video_check_business_id)

      raise resp.msg unless resp.success?

      resp["result"].each do |result|
        SyncVideoResultJob.perform_later(result)
      end
    end

    def audio_callback_results!
      resp = client.audio_callback_results(business_id: audio_check_business_id)

      raise resp.msg unless resp.success?

      resp["antispam"].each do |result|
        SyncAudioResultJob.perform_later(result)
      end
    end

    [:secret_id, :secret_key].each do |method|
      define_method method do
        send("#{method}_encrypt").present? ? YidunContentModeration.aes128_decrypt(send("#{method}_encrypt")) : nil
      end

      define_method "#{method}=" do |value|
        send("#{method}_encrypt=", YidunContentModeration.aes128_encrypt(value))
      end
    end
  end
end
