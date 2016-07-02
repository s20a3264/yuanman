class Product < ActiveRecord::Base

	has_one :photo, dependent: :destroy
	validates_presence_of :photo
	accepts_nested_attributes_for :photo

	validates :title, presence: { message: "請填寫商品名稱" }

	scope :products_are_selling, -> { where(selling: true) }

	class << self 

		def set_inventory!(current_cart)
			current_cart.cart_items.each do |item|
				product = item.product
				product.quantity -= item.quantity
				product.save
			end	
		end
	end

	def off_shelf
		self.selling = false
		self.save
	end

	def on_shelf
		self.selling = true
		self.save		
	end


end
