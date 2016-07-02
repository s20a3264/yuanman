task :p => :environment do
	Product.all.each do |p|
		p.selling = true
		p.save
		puts "#{p.title} done"
	end	
end		