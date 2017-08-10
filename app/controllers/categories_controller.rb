class CategoriesController < ApplicationController


	def index
    @products = Product.products_are_selling.includes(:photo, :category).order(created_at: :DESC)
	end

	def show
		@category = Category.find(params[:id])
    @products = @category.products.products_are_selling.includes(:photo, :category).order(created_at: :DESC)
	end

end
