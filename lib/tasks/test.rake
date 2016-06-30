task :p => :environment do
	Product.all.each do |p|
		p.quantity = 20
		p.save
		puts "#{p.id} done"
	end	
end		