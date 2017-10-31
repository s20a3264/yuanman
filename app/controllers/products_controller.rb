class ProductsController < ApplicationController


	def index

		@category_name = @category ? @category.name : "所有商品"

    @products = Product.products_are_selling.includes(:photo, :category).order(created_at: :DESC)

		@articles = Article.order(created_at: :DESC).limit(4)

		@sticky_1 = Article.find_by(sticky: 1)
		@sticky_2 = Article.find_by(sticky: 2)

		@marked_product = Product.be_marked.products_are_selling.includes(:photo, :category).order(created_at: :DESC)
	end

	def total_articles
		@articles = Article.page(params[:page]).per(10)
	end

	def show
		@product = Product.find(params[:id])
		@marked_product = Product.be_marked.products_are_selling.includes(:photo, :category).order(created_at: :DESC)
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
