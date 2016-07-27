module Manager::ProductsHelper

	def render_shelf_option(product)
		if 	product.selling == true
			link_to("下架", off_shelf_manager_product_path(product), method: :post)
		else
			link_to("上架", on_shelf_manager_product_path(product), method: :post)
		end	
	end

end
