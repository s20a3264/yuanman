class AjaxController < ApplicationController


def render_article
	@article = Article.find_by(id: params[:id])

	respond_to do |format|
		format.json {render json: @article.to_json}
	end	
end

end
