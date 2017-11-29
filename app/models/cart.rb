class Cart < ActiveRecord::Base
	has_many :cart_items, dependent: :destroy
	has_many :items, through: :cart_items, source: :product


	def add_product_to_cart(product, quantity)
		cart_item = self.cart_items.build
		cart_item.product = product
		cart_item.quantity = quantity
		cart_item.save
	end

	def quantity_plus(product)
		cart_item = self.cart_items.find_by(product_id: product.id)
		cart_item.quantity += 1
		cart_item.save 
	end

	def total_price
		sum = 0

		self.cart_items.each do |cart_item|
			sum += cart_item.product.price * cart_item.quantity
		end
		
		sum	
	end

	#確認庫存，數量不足，或完全沒貨
	def stock_check
		@hash = {}
		d_array = []
		c_array = []

		self.cart_items.each do |item|
			product = Product.find_by(id: item.product_id)
			if item.quantity > product.quantity && product.quantity == 0
				item.destroy
				d_array <<  product.title
				@hash[:delete] = d_array		
			elsif item.quantity > product.quantity
				item.quantity = product.quantity
				item.save
				c_array << product.title
				@hash[:change] = c_array
			end
		end
		@hash
	end

	#清空購物車
	def clean!
		self.cart_items.destroy_all
	end

end
