module YidunContentModeration
  module API
    module Audio
      # https://support.dun.163.com/documents/2018082201?docId=191344157972942848
      def audio_submit(url:, business_id:, callback: nil)
        http_post("/v3/audio/submit", body: {
          version: "v3.3",
          dataId: SecureRandom.uuid,
          url: url,
          businessId: business_id,
          callback: callback
        })
      end

      # https://support.dun.163.com/documents/2018082201?docId=410644689942007808
      def audio_callback_results(business_id:)
        http_post("/v3/audio/callback/results", body: {
          version: "v3.3",
          businessId: business_id
        })
      end
    end
  end
end
