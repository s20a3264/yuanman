class ManagerController < ApplicationController

	before_action :authenticate_manager!
	before_action :admin_required

	layout 'manager'

	def admin_required
		if	!current_manager.admin?
			redirect_to root_path
		end	
	end


end
