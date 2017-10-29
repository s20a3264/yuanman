class SpgatewayService

  def initialize(order, hash={})
    @merchant_id = ENV["s_merchant_id"]
    @order = order
    @timestamp = order.created_at.to_i
    @merchant_order_no = order.order_number
    @total_price = order.total
    @expiredate = order.deadline.to_s(:Ymd)

    @hash = hash
  end

  def aes_encrypt
    data = "MerchantID=#{@merchant_id}&RespondType=JSON&TimeStamp=#{@timestamp}&Version=1.4&MerchantOrderNo=#{@merchant_order_no}&Amt=#{@total_price}&ItemDesc=sample&TradeLimit=300&ExpireDate=#{@expiredate}&Email=#{@hash[:email]}&LoginType=0"
    
    url = "&ReturnURL=#{@hash[:return_url]}&NotifyURL=#{@hash[:notify_url]}&CustomerURL=#{@hash[:customer_url]}&ClientBackURL=#{@hash[:client_back_url]}"

    payment_type = "&CREDIT=1&WEBATM=1&VACC=1&CVS=1"

    str = data + url + payment_type

    cipher = OpenSSL::Cipher::AES.new(256, :CBC)

    cipher.encrypt
    cipher.key = ENV['s_hash_key']
    cipher.iv  = ENV['s_hash_iv']
    encrypted = cipher.update(str) << cipher.final
    encoded = encrypted.unpack('H*')[0]
  end

  class << self
  	#AES解密
    def aes_decrypt(data)
      aes = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
      aes.decrypt
      aes.key = ENV['s_hash_key']
      aes.iv  = ENV['s_hash_iv']
      aes.padding = 0

      decrypted_data = aes.update([data].pack('H*')) << aes.final
      decrypted_data.force_encoding('UTF-8')

      self.strippadding(decrypted_data)

    end

    def strippadding(decrypted_data)
        padding_num = decrypted_data[-1].ord
        padding_chr = decrypted_data[-1]
      if /#{padding_chr}{#{padding_num}}/i.match(decrypted_data)
        decrypted_data_length = decrypted_data.size - padding_num -1
        decrypted_data[0..decrypted_data_length]
      else
        decrypted_data  
      end      
    end

  end

  def sha256_encrypt
    str = self.aes_encrypt
    encrypted = "HashKey=#{ENV['s_hash_key']}&#{str}&HashIV=#{ENV['s_hash_iv']}"
    Digest::SHA256.hexdigest(encrypted).upcase
  end



end	