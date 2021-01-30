require "yidun_content_moderation/engine"
require "yidun_content_moderation/api"
require "yidun_content_moderation/client"
require "yidun_content_moderation/result"

module YidunContentModeration
  mattr_accessor :aes_key

  def self.configuration
    yield self
  end

  def self.aes128_encrypt(data)
    return nil if data.blank?
    cipher = OpenSSL::Cipher::AES.new(128, :ECB)
    cipher.encrypt
    cipher.key = aes_key
    Base64.strict_encode64(cipher.update(data.to_s) << cipher.final)
  end

  def self.aes128_decrypt(data)
    cipher = OpenSSL::Cipher::AES.new(128, :ECB)
    cipher.decrypt
    cipher.key = aes_key
    cipher.update(Base64.decode64(data)) << cipher.final
  end
end
