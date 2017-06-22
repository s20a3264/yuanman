
class Pay2goService

  def initialize(order, hash={})
    @order = order
    @timestamp = order.created_at.to_i
    @merchant_order_no = order.order_number
    @total_price = order.total
    @hash_key = ENV['hash_key']
    @hash_iv = ENV['hash_iv']
    @merchant_id = ENV['merchant_id']
    @hash = hash
  end

  def aes_encrypt
    str = "MerchantID=#{@merchant_id}&TimeStamp=#{@timestamp}&Version=1.0&MerchantOrderNo=#{@merchant_order_no}&Amt=#{@total_price}&ItemDesc=sample"
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = ENV['hash_key']
    cipher.iv  = ENV['hash_iv']
    encrypted = cipher.update(str) << cipher.final
    encoded = encrypted.unpack('H*')[0]
  end

  class << self
  def aes_decrypt(key, decrypted_string)
    aes = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    aes.decrypt
    aes.key = key
    str = aes.update([decrypted_string].pack('H*')) << aes.final
    str.force_encoding('UTF-8')
  end
  end

    class << self
      def test
        s = "MerchantID=PG300000000055&TimeStamp=1489630207&Version=1.0&MerchantOrderNo=S_1489630207&Amt=30&ItemDesc=UnitTest"
        cipher = OpenSSL::Cipher::AES.new(128, :CBC)
        cipher.encrypt
        cipher.key = "12345678901234567890123456789012"
        cipher.iv  = "1234567890123456"
        encrypted = cipher.update(s) << cipher.final
      end
      end

    def decrypt(data)
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.decrypt
      cipher.key = ENV['hash_key']
      cipher.iv  = ENV['hash_iv']
      cipher.update(data) << cipher.final
    end

    def sha256_encrypt
      str = self.aes_encrypt

      encrypted = "HashKey=#{ENV['hash_key']}&#{str}&HashIV=#{ENV['hash_iv']}"
      Digest::SHA256.hexdigest(encrypted).upcase
    end



  def check(code)
    @code = self.send(code)
    d = Digest::SHA256.hexdigest(@code).upcase
  end

  def check_code
    "HashIV=#{@hash_iv}&Amt=#{@total_price}&MerchantID=#{@merchant_id}&MerchantOrderNo=#{@merchant_order_no}&TradeNo=#{@hash[:TradeNo]}&HashKey=#{@hash_key}"
  end

  def check_value
    "HashKey=#{@hash_key}&Amt=#{@total_price}&MerchantID=#{@merchant_id}&MerchantOrderNo=#{@merchant_order_no}&TimeStamp=#{@timestamp}&Version=1.2&HashIV=#{@hash_iv}"
  end

  def state_query
    "IV=#{Pay2go.hash_iv}&Amt=#{@total_price}&MerchantID=#{Pay2go.merchant_id}&MerchantOrderNo=#{@merchant_order_no}&Key=#{Pay2go.hash_key}"
  end

end
