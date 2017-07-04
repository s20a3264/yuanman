task :pp => :environment do
	Product.all.each do |product|
		product.origin = "台灣"
		product.weight = "200公克"
		product.expiration_date = "六個月"
		product.save
		puts "#{product.title} done!"
	end
end			

task :sticky => :environment do
	Article.all.each do |article|
		article.sticky = 0

		article.save
		puts "#{article.title} done!"
	end
end			