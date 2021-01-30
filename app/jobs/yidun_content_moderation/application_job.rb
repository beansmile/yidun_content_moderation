module YidunContentModeration
  class ApplicationJob < ActiveJob::Base
    queue_as :yidun_content_moderation
  end
end
