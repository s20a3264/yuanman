class Setting < ActiveRecord::Base
	mount_uploader :carousel1, CarouselUploader
	mount_uploader :carousel2, CarouselUploader
	mount_uploader :carousel3, CarouselUploader

	#phone輪播
	mount_uploader :carousel1_p, CarouselPhoneUploader
	mount_uploader :carousel2_p, CarouselPhoneUploader
	mount_uploader :carousel3_p, CarouselPhoneUploader	
end
