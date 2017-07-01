class Manager::ArticlesController < ApplicationController

	def index
		@articles = Article.all
	end

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

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])

		if @article.update(article_params)
			redirect_to manager_article_path(@article)
		else
		 render :edit
		end 		
	end

	def show
		@article = Article.find(params[:id])

	end

	private

		def article_params
			params.require(:article).permit(:title, :description, :article_img)
		end

end