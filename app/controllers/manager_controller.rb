class ManagerController < ApplicationController

	before_action :authenticate_manager!
	before_action :admin_required

	layout 'manager'


end
