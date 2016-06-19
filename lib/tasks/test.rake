task :set_quantity => :environment do
	Product.all.each do |p|
		p.quantity = 15
		p.save
		puts "#{p.title} done"
	end	
end		