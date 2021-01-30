module YidunContentModeration
  class SyncImageResultJob < ApplicationJob
    def perform(task)
      task.sync_image_result!
    end
  end
end
