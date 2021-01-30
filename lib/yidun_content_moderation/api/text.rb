module YidunContentModeration
  module API
    module Text
      # https://support.dun.163.com/documents/2018041901?docId=424375611814748160
      def text_check(content:, business_id:)
        http_post("/v4/text/check", body: {
          dataId: SecureRandom.uuid,
          content: content,
          businessId: business_id,
          version: "v4"
        })
      end

      # https://support.dun.163.com/documents/2018041901?docId=424382077801385984
      def text_batch_check(texts:, business_id:)
        http_post("/v4/text/batch-check", body: {
          texts: texts,
          businessId: business_id,
          version: "v4"
        })
      end
    end
  end
end
