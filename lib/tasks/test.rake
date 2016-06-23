task :d_cart => :environment do
	Cart.all.each do |p|
		p.destroy
		puts "#{p.id} done"
	end	
end		