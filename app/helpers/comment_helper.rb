module CommentHelper
	def render_comment_title(comment)
		if !comment.title.nil?
			content_tag(:label, comment.title, class: "comment-title")
		end	
	end
end
