module YidunContentModeration
  class SyncVideosResultJob < ApplicationJob
    def perform
      # TODO 暂时只处理只有一个Application的场景
      application = Application.first

      application.video_callback_results! if application.tasks.pending.where("created_at >= ?", 1.days.ago).first
    end
  end
end
