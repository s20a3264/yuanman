class Manager::CoreController < ManagerController

	def index
		@products = Product.all.includes(:photo)
	end

	def zbc

		clnt = HTTPClient.new
		@a = clnt.get_content("https://capi.pay2go.com/API/QueryTradeInfo")
	end
end
