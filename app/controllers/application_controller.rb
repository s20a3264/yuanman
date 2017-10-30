class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_cart

  before_action :setting, :categories


  def current_cart
  	@current_cart ||= find_cart
  end



  private

  def find_cart
  	cart = Cart.find_by(id: session[:cart_id])

  	unless cart.present?
  		cart = Cart.create
  	end
  	
  	session[:cart_id] = cart.id

  	cart	
  end

  def cart_items_to_hash
    @cart_items_hash = {}
    current_cart.cart_items.each do |item|
      @cart_items_hash[item.product_id] = item.quantity 
    end
    @cart_items_hash
  end

  def setting
    @setting = Setting.last
  end

  def categories
    @categories = Category.all  
  end

	
end
