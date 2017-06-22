Pay2go.setup do |pay2go|
  if Rails.env.development?
    pay2go.merchant_id = "PG100000002345"  # 放測試站的 key


    pay2go.hash_key    = "q4kNXhSy0hzohwrLPeGstcRT6rkYCyZ2"
    pay2go.hash_iv     = "DjPABH9BZI0gfr24"
    pay2go.service_url = "https://cpayment.pay2go.com/MPG/mpg_gateway"
  else
    pay2go.merchant_id = "PG100000002345"  # 放正式站的 key

    pay2go.hash_key    = "q4kNXhSy0hzohwrLPeGstcRT6rkYCyZ2"
    pay2go.hash_iv     = "DjPABH9BZI0gfr24"
    pay2go.service_url = "https://cpayment.pay2go.com/MPG/mpg_gateway"
  end
end