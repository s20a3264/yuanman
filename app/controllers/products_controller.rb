class ProductsController < ApplicationController

	def index
		@products = Product.products_are_selling.includes(:photo, :category).order(created_at: :DESC)
		@setting = Setting.last
	end

	def show
		@product = Product.find(params[:id])
	end

	def add_to_cart
		@product = Product.find_by(id: params[:id])
		quantity = params[:quantity]

		if !current_cart.items.include?(@product)
			current_cart.add_product_to_cart(@product, quantity)
			flash[:notice] = "你已成功將 #{@product.title} #{params[:quantity]}個加入購物車"
		else	
			flash[:warning] = "購物車內已有此物品"
		end
			
		redirect_to :back

		rescue

    logger.error("Attempt to access invalid product #{params[:id]}")
    flash[:notice] = '商品不存在或已被刪除'
    redirect_to root_path

	end


end
