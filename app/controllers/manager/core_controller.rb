class Manager::CoreController < ManagerController

	def index
		session[:query_days] ||= "30"
		session[:order]   ||= "DESC"
		ob = session[:order]
		interval = session[:query_days].to_i
		query_scope =  params["query_scope"] ? params["query_scope"] : "undone_orders"
		@orders = Order.last_days(interval).includes(:user).send(query_scope).order("created_at #{ob}").page(params[:page]).per(5)
	end

	def set_session
		array = ["p_order", "order_by", "order", "query_days"]
		array.each do |key|
			if params[key]
				session[key] = params[key]
			end
		end	

		redirect_to :back
	  rescue
	  	redirect_to manager_index_path
 	end

	def clear
		session.delete("query_days")
		redirect_to :back 
	end


	def zbc

		clnt = HTTPClient.new
		@a = clnt.get_content("https://capi.pay2go.com/API/QueryTradeInfo")
	end
end
