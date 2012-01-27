namespace :green_light do

  desc 'Generates jquery.validate translations of model validation rules'
  task update_validations: :environment do
    validation_rules = GreenLight::Rules.new.to_json

    dir = GreenLight::Config.output_dir
    Dir.mkdir( dir ) unless File.exists?( dir )
    f = File.open( "#{dir}/#{GreenLight::Config.output_file}", 'w' )
    f.puts "#{GreenLight::Config.output_var} = #{validation_rules};"
    f.close
  end

end
