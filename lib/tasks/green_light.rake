require 'yaml'

namespace :green_light do

  desc 'Generates jquery.validate translations of model validation rules'
  task update_validations: :environment do
    validation_rules = GreenLight::Rules.generate( GREEN_LIGHT[:validate_models] )

    f = File.open( "#{dir}/green_light_validations.js", 'w' )
    f.puts validation_rules
    f.close
  end

end
