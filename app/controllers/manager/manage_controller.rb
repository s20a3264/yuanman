class Manager::ManageController < ManagerController

	def index
		@products = Product.all
	end


end
