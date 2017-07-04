class Manager::SettingsController < ManagerController

	def index
		
	end

	def create
		if @setting.save
			redirect_to root_path(@setting)
		else
		 render :edit
		end 				
	end


	def edit
	end

	def update

		if @setting.update(setting_params)
			redirect_to manager_settings_path
		else
		 render :back
		end 		
	end

	private

		def setting_params
			params.require(:setting).permit(:carousel1, :carousel2, :carousel3, 
				:carousel1_link, :carousel2_link, :carousel3_link, :about_us, :q_and_a, :notice,
				:email, :line, :phone, :shipping_cost, :shipping_free)
		end
end
