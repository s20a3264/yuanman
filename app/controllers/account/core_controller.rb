class Account::CoreController < ApplicationController
	before_action :authenticate_user!

	def index
	end

	def user_info
		@info = current_user.info
	end

	def build_user_info
		@info = current_user.info
		array = ["shipping_name", "shipping_address", "phone_number", "postal_code"]
		array.each do |key|
			@info[key] = params[key]
		end
		current_user.save

		flash[:success] = "資料更新成功"
		redirect_to :back	

	  rescue
	  	flash[:warning] = "發生錯誤，請再試一次"
	    redirect_to :back	
	end

end
