module YidunContentModeration
  class SyncVideoResultJob < ApplicationJob
    def perform(result)
      Task.find_by(yidun_task_id: result["taskId"], check_type: :video).sync_video_result!(result)
    end
  end
end
