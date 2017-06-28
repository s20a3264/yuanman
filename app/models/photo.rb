class Photo < ActiveRecord::Base

	belongs_to :product

	mount_uploader :image, ImageUploader

	# validates :image, presence: { message: "請上傳相片"}

end
