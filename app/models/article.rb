class Article < ActiveRecord::Base
	mount_uploader :article_img, ArticleImgUploader
end
