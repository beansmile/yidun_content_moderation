# frozen_string_literal: true

module YidunContentModeration
  class Task < ApplicationRecord
    # constants

    # concerns

    # attr related macros
    serialize :response, JSON

    enum state: {
      pending: 0,
      passed: 1,
      need_audit: 2,
      refused: 3
    }

    enum check_type: {
      image: 0,
      video: 1,
      audio: 2
    }, _suffix: true

    # association macros
    belongs_to :application, class_name: "YidunContentModeration::Application"

    # validation macros
    validates :name, uniqueness: true

    # callbacks
    after_create_commit :enqueue_sync_image_result_job, if: :image_check_type?

    # other macros

    # scopes

    # class methods

    # instance methods
    def sync_audio_result!(result)
      update(response: result)

      case result["action"]
      when 0 # 建议通过
        passed!
      when 1 # 建议审核
        need_audit!
      when 2 # 建议删除
        refused!
      end
    end

    def sync_video_result!(result)
      update(response: result)

      case result["status"]
      when 0
        result["evidences"].empty? ? passed! : refused!
      else
        raise result["status"]
      end
    end

    def sync_image_result!
      resp = application.image_async_result(task_ids: [yidun_task_id])

      raise resp.msg unless resp.success?

      enqueue_sync_image_result_job if resp["antispam"].empty?

      result = resp["antispam"].detect do |data|
        data["taskId"] == yidun_task_id
      end

      update(response: result)

      case result["action"]
      when 0 # 建议通过
        passed!
      when 1 # 建议审核
        need_audit!
      when 2 # 建议删除
        refused!
      end

      resp
    end

    def enqueue_sync_image_result_job
      SyncImageResultJob.set(wait: 15.seconds).perform_later(self)
    end
  end
end
