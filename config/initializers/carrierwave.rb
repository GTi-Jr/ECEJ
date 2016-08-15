CarrierWave.configure do |config|

  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     Rails.application.secrets.s3_access_key_id,            # required
    aws_secret_access_key: Rails.application.secrets.s3_secret_access_key,            # required
    region:                'us-east-1',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'almej'                          # required
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end
