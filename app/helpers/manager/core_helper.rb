module Manager::CoreHelper
	def manager_link(name, options, html_options = {})
		if manager_signed_in?
			link_to(name, options, html_options)
		end	
	end
end
