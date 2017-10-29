module SpgatewayHelper


	#智付通回傳位置，用URL method因cloudflare會用301轉址導致post變get
	def s_customer_url
		if Rails.env.production?
			"https://www.yuanman.com.tw/spgateway_customer"
		else
			spgateway_customer_url
		end		
	end

	def s_notify_url
		if Rails.env.production?
			"https://www.yuanman.com.tw/spgateway_notify"
		else
			spgateway_notify_url
		end		
	end

	def s_return_url
		if Rails.env.production?
			"https://www.yuanman.com.tw/spgateway_return"
		else
			spgateway_return_url
		end		
	end		

end
