class Product < ActiveRecord::Base

	mount_uploader :certification, CertificationUploader
	mount_uploader :nutrition_facts,  NutritionFactsUploader

	belongs_to :category
	has_one :photo, dependent: :destroy

	# validates_presence_of :photo

	accepts_nested_attributes_for :photo

	validates :title, presence: { message: "請填寫商品名稱" }

	scope :products_are_selling, ->{ where(selling: true) }


	#上架的商品
	scope :selling, -> { where(selling: true) }
	#下架的商品
	scope :unselling, -> { where(selling: false)}
	#置頂的商品
	scope :be_marked, -> { where(mark: true) }

	attr_accessor :category_name

	before_save :find_or_create_category

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

	private
		def find_or_create_category
			if @category_name && !category_name.empty?
				category = Category.find_by(name: @category_name)
				if category.nil?
					self.create_category(name: @category_name)
				else
					self.category = category
				end
			end			
		end


end
