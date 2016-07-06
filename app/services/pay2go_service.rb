class Pay2goService

  def initialize(order)
    @order = order
    @timestamp = order.created_at.to_i
    @merchant_order_no = order.order_number
    @total_price = order.for_pay2go
  end

  def check(code)
    @code = self.send(code)
    d = Digest::SHA256.hexdigest(@code).upcase
  end

  def check_value
    "HashKey=#{ENV['hash_key']}&Amt=#{@total_price}&MerchantID=#{ENV['merchant_id']}&MerchantOrderNo=#{@merchant_order_no}&TimeStamp=#{@timestamp}&Version=1.2&HashIV=#{ENV['hash_iv']}"
  end

  def state_query
    "IV=#{Pay2go.hash_iv}&Amt=#{@total_price}&MerchantID=#{Pay2go.merchant_id}&MerchantOrderNo=#{@merchant_order_no}&Key=#{Pay2go.hash_key}"
  end

end
