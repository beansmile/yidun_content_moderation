module YidunContentModeration
  module API
    module Image
      # https://support.dun.163.com/documents/2018041902?docId=424387300808773632
      def image_check(images:, business_id:)
        http_post("/v4/image/check", body: {
          dataId: SecureRandom.uuid,
          images: images,
          businessId: business_id,
          version: "v4"
        })
      end

      # https://support.dun.163.com/documents/2018041902?docId=484530088331259904
      def image_async_check(images:, business_id:)
        http_post("/v4/image/asyncCheck", body: {
          dataId: SecureRandom.uuid,
          images: images,
          businessId: business_id,
          version: "v4"
        })
      end

      # https://support.dun.163.com/documents/2018041902?docId=484530088331259904#%E5%9B%BE%E7%89%87%E5%BC%82%E6%AD%A5%E8%8E%B7%E5%8F%96%E6%A3%80%E6%B5%8B%E7%BB%93%E6%9E%9C
      def image_async_result(task_ids:, business_id:)
        http_post("/v4/image/asyncResult", body: {
          taskIds: task_ids,
          businessId: business_id,
          version: "v4"
        })
      end
    end
  end
end
