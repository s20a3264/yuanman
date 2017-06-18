CarrierWave.configure do |config|
  if Rails.env.production? 
    config.storage :fog                       
    config.fog_credentials = {
      provider:              'AWS',                        
      aws_access_key_id:     'AKIAJC3H75I6Z3GMQMAA',           

      aws_secret_access_key: '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'   

    }
    config.fog_directory  = 'forestore' 

  else
    config.storage :file
  end
end