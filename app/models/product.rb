class Product < ActiveRecord::Base

	has_one :photo, dependent: :destroy
	validates_presence_of :photo
	accepts_nested_attributes_for :photo

	validates :title, presence: { message: "請填寫商品名稱" }
end
