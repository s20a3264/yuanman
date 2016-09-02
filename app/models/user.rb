class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	
	has_many :orders

	def info_build(hash)
	  self.info[:shipping_name]    = hash[:info_attributes][:shipping_name]
	  self.info[:shipping_address] = hash[:info_attributes][:shipping_address]
	  self.info[:phone_number]     = hash[:info_attributes][:phone_number]
	  self.info[:postal_code]     = hash[:info_attributes][:postal_code]	  
	  self.save
	end   
end
