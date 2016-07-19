class Order < ActiveRecord::Base
	include AASM

	belongs_to :user

	has_many :items, class_name: "OrderItem", dependent: :destroy
	has_one  :info,  class_name: "OrderInfo", dependent: :destroy
	has_many :comments, as: :commentable

	accepts_nested_attributes_for :info

	before_create :generate_token, :generate_order_number

	def generate_token
		self.token = SecureRandom.uuid
	end

	def generate_order_number
		random_code = SecureRandom.uuid.gsub(/-/, '').upcase[0, 8]
		self.order_number = Time.zone.now.strftime("%y%m%d%H%M%S") + random_code
	end

	def build_item_cache_from_cart(cart)
		cart.items.each do |cart_item|
			item = self.items.build 
			item.product_name = cart_item.title
			item.quantity = cart.cart_items.find_by(product_id: cart_item).quantity
			item.price = cart_item.price
			item.save
		end	
	end

	def calculate_total!(cart)
		self.total = cart.total_price + 100
		self.save
	end

	def pay!
		self.update_columns(is_paid: true )
	end

	def complete_payment(method, info)
		self.make_payment!
		self.update_columns(payment_method: method, trade_info: info)
  end

  def cancel
  	case self.aasm_state
  	when "order_placed"
  		self.cancel_order!
  	when "paid"	
  		self.cancel_payment_order!
  	end	
  end

	aasm do 
		state :order_placed, initial: true
		state :number_received
		state :paid
		state :shipped
		state :refund_processing
		state :order_cancelled
		state :return_processing
		state :good_returned
		state :good_return_failed

		event :take_a_number do
			transitions from: :order_placed,						to: :number_received
		end
		
		event :nonreal_time_payment, after_commit: :pay! do
			transitions from: :number_received,					to: :paid
		end

		event :make_payment, after_commit: :pay! do 
			transitions from: :order_placed, 						to: :paid
		end
		
		event :ship do 
			transitions from: :paid, 										to: :shipped
		end

		event :cancel_payment_order do 
			transitions from: :paid,										to: :refund_processing 
		end
		
		event :refund_completed do
			transitions from: :refund_processing,				to: :order_cancelled
		end	

		event :cancel_order do 
			transitions from: [:order_placed, :paid], 	to: :order_cancelled
		end	

		event :request_good_returned do
			transitions from: :shipped, 								to: :return_processing
		end
		
		event :return_good do 
			transitions from: :return_processing,			  to: :good_returned
		end	
		
		event :return_fail do
			transitions from: :return_processing, 			to: :good_return_failed
		end		

	end	

end
