# frozen_string_literal: true

require "httparty"

module YidunContentModeration
  class Client
    include HTTParty
    include API::Text
    include API::Image
    include API::Audio
    include API::Video

    HTTP_ERRORS = [
      EOFError,
      Errno::ECONNRESET,
      Errno::EINVAL,
      Net::HTTPBadResponse,
      Net::HTTPHeaderSyntaxError,
      Net::ProtocolError,
      Timeout::Error
    ]
    TIMEOUT = 5

    @@logger = ::Logger.new("./log/yidun_content_moderation.log")

    base_uri "http://as.dun.163.com"

    attr_accessor :secret_id, :secret_key

    def initialize(secret_id:, secret_key:)
      @secret_id = secret_id
      @secret_key = secret_key
    end

    [:get, :post].each do |method|
      define_method "http_#{method}" do |path, options = {}|
        body = (options[:body] || {}).select { |_, v| !v.nil? }.reverse_merge({
          secretId: secret_id,
          timestamp: Time.current.to_datetime.strftime('%Q'),
          nonce: rand(99999999999)
        })
        body[:signature] = Digest::MD5.hexdigest("#{body.sort_by{ |key, _| key }.flatten.join}#{secret_key}".encode("UTF-8"))

        headers = (options[:headers] || {}).reverse_merge({
          "Content-Type" => "application/x-www-form-urlencoded",
          "Accept-Encoding" => "*"
        })

        uuid = SecureRandom.uuid

        @@logger.debug("request[#{uuid}]: method: #{method}, url: #{path}, body: #{body}, headers: #{headers}")

        response = begin
                     resp = self.class.send(method, path, body: URI.encode_www_form(body), headers: headers, timeout: TIMEOUT)

                     if resp.success?
                       JSON.parse(resp.body)
                     else
                       { "msg" => "请求错误（code: #{resp.code})" }
                     end
                   rescue JSON::ParserError
                     resp
                   rescue *HTTP_ERRORS
                     { "msg" => "连接超时" }
                   end

        @@logger.debug("response[#{uuid}]: #{response}")
        Result.new(response)
      end
    end
  end
end
