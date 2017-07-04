task :pp => :environment do
	Product.all.each do |product|
		product.origin = "台灣"
		product.weight = "200公克"
		product.expiration_date = "六個月"
		product.save
		puts "#{product.title} done!"
	end
end			