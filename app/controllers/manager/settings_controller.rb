class Manager::SettingsController < ApplicationController

	def create
		@setting = Setting.new(setting_params)
		if @setting.save
			redirect_to root_path(@setting)
		else
		 render :edit
		end 				
	end


	def edit
		@setting = Setting.last ? Setting.last : Setting.new
	end

	def update
		@setting = Setting.last ? Setting.last : Setting.new(setting_params)

		if @setting.update(setting_params)
			redirect_to root_path(@setting)
		else
		 render :edit
		end 		
	end

	private

		def setting_params
			params.require(:setting).permit(:carousel1, :carousel2, :carousel3)
		end
end
