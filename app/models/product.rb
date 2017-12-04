class Product < ActiveRecord::Base

	before_save :should_generate_new_friendly_id?

	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged

	mount_uploader :certification, CertificationUploader
	mount_uploader :nutrition_facts,  NutritionFactsUploader

	belongs_to :category
	has_one :photo, dependent: :destroy

	# validates_presence_of :photo

	accepts_nested_attributes_for :photo

	validates :title, presence: { message: "請填寫商品名稱" }
	validates :price, presence: { message: "請輸入商品價格" }
	validate :valid_special_price

	scope :products_are_selling, ->{ where(selling: true) }


	#上架的商品
	scope :selling, -> { where(selling: true) }
	#下架的商品
	scope :unselling, -> { where(selling: false)}
	#置頂的商品
	scope :be_marked, -> { where(mark: true) }
	#特價的商品
	scope :special_price, -> { where(special: true) }
	#缺貨的商品
	scope :out_of_stock, -> { where(quantity: 0) }


	attr_accessor :category_name

	before_save :find_or_create_category

	# 驗證特價時特價價格不能為空
	def valid_special_price
		if self.special && self.special_price.blank?
			errors.add(:special, "必須設定特價價格")
		end	
	end

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

	#讓friendly_id能使用中文
	def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

  #title重複時找price
  def slug_candidates
    [
      :title,
      [:title, :price]
    ]
  end

  def should_generate_new_friendly_id?
  	slug.blank? || title_changed? # slug 為 nil 或 name column 變更時更新
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
