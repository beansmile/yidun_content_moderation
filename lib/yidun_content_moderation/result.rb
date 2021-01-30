# frozen_string_literal: true

module YidunContentModeration
  class Result < ::Hash
    def initialize(result)
      result.each_pair do |k, v|
        self[k] = v
      end
    end

    def success?
      self["code"] == 200
    end

    def msg
      "yidun: #{self["msg"]}"
    end
  end
end
