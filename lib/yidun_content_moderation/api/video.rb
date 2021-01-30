module YidunContentModeration
  module API
    module Video
      # https://support.dun.163.com/documents/2018041903?docId=150440843651764224
      def video_submit(url:, business_id:, callback: nil)
        http_post("/v3/video/submit", body: {
          version: "v3.1",
          dataId: SecureRandom.uuid,
          url: url,
          businessId: business_id,
          callback: callback
        })
      end

      # https://support.dun.163.com/documents/2018041903?docId=150440859531399168
      def video_callback_results(business_id:)
        http_post("/v3/video/callback/results", body: {
          version: "v3.1",
          businessId: business_id
        })
      end
    end
  end
end
