task :p => :environment do
	Order.all.each do |p|
		case p.aasm_state

		when "paid"
			p.undone = true
			p.save
			puts "#{p.id} set undone = true"
		when "refund_processing"
			p.undone = true
			p.save
			puts "#{p.id} set undone = true"
		when "return_processing"
			p.undone = true
			p.save
			puts "#{p.id} set undone = true"		
		else
			p.undone = false
			p.save
			puts "#{p.id} set undone = false"					
		end	
	end	
end		