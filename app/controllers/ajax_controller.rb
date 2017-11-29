class AjaxController < ApplicationController


	def render_article
		@article = Article.find_by(id: params[:id])
	
		respond_to do |format|
			format.json {render json: @article.to_json}
		end	
	end

	def add_to_cart
		@product = Product.find_by(id: params['id'])
		quantity = 1

		if !current_cart.items.include?(@product)
			current_cart.add_product_to_cart(@product, quantity)
		else
			item = current_cart.quantity_plus(@product)
		end

		quantity = current_cart.items.count

		respond_to do |format|
			format.json {render json: {quantity: "#{quantity}"}}
		end	

	end

end
