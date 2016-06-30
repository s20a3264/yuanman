class Manager::CoreController < ManagerController

	def index
		@products = Product.all.includes(:photo)
	end
end
