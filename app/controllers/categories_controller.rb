class CategoriesController < ApplicationController


	def index
		if params[:on_sale]
    	@products = Product.special_price.includes(:photo, :category).order(created_at: :DESC)
    	@title = "特價商品"
		else
    	@products = Product.products_are_selling.includes(:photo, :category).order(created_at: :DESC)
    	@title = "所有產品"
    end	
	end

	def show
		@category = Category.find(params[:id])
    @products = @category.products.products_are_selling.includes(:photo, :category).order(created_at: :DESC)
	end

end
