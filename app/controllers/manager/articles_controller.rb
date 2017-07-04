class Manager::ArticlesController < ApplicationController

	def index
		@articles = Article.page(params[:page]).per(10).order(created_at: :DESC)
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


	def destroy
		@article = Article.find(params[:id])

		if @article.destroy

			flash[:success] = "#{@article.title} 已被刪除"
			redirect_to :back
		else
			render :index
		end	
	end	


	def sticky
		@article = Article.find_by(id: params[:id])

		position = params[:position].to_i
		now_sticky = Article.find_by(sticky: position)


		if now_sticky
			now_sticky.sticky = 0
			now_sticky.save
		end
		
		@article.sticky = position
		@article.save

		redirect_to :back			

	end

	def sticky_cancel
		@article = Article.find_by(id: params[:id])
		@article.sticky = 0
		@article.save
		redirect_to :back			
	end


	private

		def article_params
			params.require(:article).permit(:title, :description, :article_img)
		end

end
