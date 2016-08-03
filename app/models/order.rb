class Order < ActiveRecord::Base
	include AASM

	belongs_to :user

	has_many :items, class_name: "OrderItem", dependent: :destroy
	has_one  :info,  class_name: "OrderInfo", dependent: :destroy
	has_many :comments, as: :commentable

	#待處理訂單
	scope  :undone_orders, 	-> {where(undone: true)}
	#已付款訂單
	scope  :paid_orders,   	-> {where(aasm_state: "paid")}
	#訂單需退款
	scope  :refund_orders, 	-> {where(aasm_state: ["refund_processing", "return_processing"])}
	#信用卡付款訂單
	scope  :cc_orders, 			-> {where(payment_method: "credit_card")}
	#超商繳費訂單

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
		self.update_columns(is_paid: true)
	end

	#儲存交易回傳訊息
	def store_trade_info(info)
		self.update_columns(trade_info: info)
	end

	#儲存非即時支付取號資訊以及繳費期限
	def store_payment_info(info)
		deadline = Time.zone.now.advance(days: 1)
		self.update_columns(payment_info: info, deadline: deadline)
	end

	def complete_payment(method)
		self.update_columns(payment_method: method, is_paid: true)
		self.make_payment!
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
		
		event :nonreal_time_payment do
			transitions from: :number_received,					to: :paid
		end

		event :make_payment do 
			transitions from: [:order_placed, :number_received], to: :paid
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
