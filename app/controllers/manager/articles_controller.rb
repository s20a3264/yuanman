class Manager::ArticlesController < ApplicationController

	def new
		@article = Article.new
	end

	def create
		@article = Article.new(article_params)

		if @article.save
			redirect_to root_path
		else
			render :new
		end		
	end

	private

		def article_params
			params.require(:article).permit(:title, :description, :article_img)
		end

end
