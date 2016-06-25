class OrderInfo < ActiveRecord::Base
	belongs_to :order

	validates :shipping_name,    presence: true
	validates :shipping_address, presence: true	
end
