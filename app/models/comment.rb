class Comment < ActiveRecord::Base
	belongs_to :commentable, polymorphic: true

	validates :content, presence: {message: "請勿空白"}
end
