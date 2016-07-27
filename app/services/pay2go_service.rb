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
