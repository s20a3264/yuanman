task :pp => :environment do
	Order.all.each do |order|
		order.items.each do |item|
			if !item.product_id
				item.product_id = Product.find_by(title: item.product_name) ? Product.find_by(title: item.product_name).id : nil
				item.save				
			end
		end
	end
end			