class Setting < ActiveRecord::Base
	mount_uploader :carousel1, CarouselUploader
	mount_uploader :carousel2, CarouselUploader
	mount_uploader :carousel3, CarouselUploader
end
