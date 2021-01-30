module YidunContentModeration
  class SyncAudioResultJob < ApplicationJob
    def perform(result)
      Task.find_by(yidun_task_id: result["taskId"], check_type: :audio).sync_audio_result!(result)
    end
  end
end
