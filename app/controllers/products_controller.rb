class ProductsController < ApplicationController

	def index
		@products = Product.all.includes(:photo).order(created_at: :asc)
	end

	def show
		@product = Product.find(params[:id])
	end

	def add_to_cart
		@product = Product.find(params[:id])
		quantity = params[:quantity]

		if !current_cart.items.include?(@product)
			current_cart.add_product_to_cart(@product, quantity)
			flash[:notice] = "你已成功將 #{@product.title} #{params[:quantity]}個加入購物車"
		else	
			flash[:warning] = "購物車內已有此物品"
		end
			
		redirect_to :back
	end

end
