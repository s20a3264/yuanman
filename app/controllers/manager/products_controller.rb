class Manager::ProductsController < ManagerController


	def index
		session[:p_order] ||= "DESC"
		session[:order_by] ||= "id"
		po = session[:p_order]
		ob = session[:order_by]
		query_scope =  params["query_scope"] ? params["query_scope"] : "all"
		@products = Product.includes(:photo).send(query_scope).order("#{ob} #{po}").page(params[:page]).per(10)
	end

	def new
		@product = Product.new
		@photo = @product.build_photo
	end

	def create
		@product = Product.new(product_params)

		if @product.save
			redirect_to product_path(@product)
		else
			render :new
		end		
	end

	def edit
		@product = Product.find(params[:id])
		@photo = @product.photo || @product.build_photo
	end

	def update
		@product = Product.find(params[:id])

		if @product.update(product_params)
			redirect_to product_path(@product)
		else
		 render :edit
		end 	
	end

	def destroy
		@product = Product.find(params[:id])

		if @product.destroy

			flash[:success] = "#{@product.title} 已被刪除"
			redirect_to :back
		else
			render :index
		end	
	end

	def off_shelf
		@product = Product.find(params[:id])
		@product.off_shelf

		flash[:success] = "#{@product.title} 已下架"
		redirect_to :back
	end

	def on_shelf
		@product = Product.find(params[:id])
		@product.on_shelf

		flash[:success] = "#{@product.title} 已上架"
		redirect_to :back		
	end

	def replenish
		@product = Product.find_by(id: params[:id])
		@product.quantity += params[:number].to_i
		
		if @product.save
			flash[:success] = "#{@product.title}庫存數量增加 #{params[:number].to_i}，庫存變化 #{@product.quantity - params[:number].to_i} => #{@product.quantity} "

		  redirect_to :back
		end
		rescue
			flash[:warning] = "操作失敗，請重新嘗試，補貨數量請填入整數"  
			redirect_to :back
	end

	#商品置頂
	def mark
		if Product.be_marked.count < 5

			product = Product.find_by(id: params[:id])
			product.mark = true
			product.save
	
			flash[:success] = "#{product.title} 已置頂"
	
			redirect_to :back
		else
			flash[:warning] = "置頂數量已滿，請先將部分產品取消置頂"
			redirect_to :back
		end		
	end

	#取消置頂
	def unmark
		product = Product.find_by(id: params[:id])
		product.mark = false
		product.save

		flash[:success] = "#{product.title} 已取消置頂"

		redirect_to :back		
	end



	private

		def product_params
			params.require(:product).permit(:title, :description, :quantity, :price, :category_name,
																			 :category_id, :nutrition_facts, :certification, :origin,
																			 :introduction, :weight, :expiration_date, :special,
																			 :special_price, photo_attributes: [:image, :id])
		end

end
