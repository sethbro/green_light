require_relative 'translations/jquery_validate'

module GreenLight
  class Rules
    include ::GreenLight::Translations::JQueryValidate

    def generate( models=nil )
      models ||= ::GreenLight::Config.models
      rules, messages = {}, {}

      models.each do |model|

        model.constantize._validators.each do |field_name, validators|
          rules.merge( validation_rules( model, field_name, validators ) )
          messages.merge( error_messages( model, field_name, validators ) )
        end
      end

      rules.merge( messages ).to_json.html_safe
    end


    private

    def error_messages( model, field_name, validators )
      msg_hash = {}
      @model, @field_name = model, field_name

      validators.each do |validator|
        @validator = validator
        err = ActiveModel::Errors.new( model.constantize.new )
        puts '>>>> err = ' << err.generate_message( field_name, @validator.kind )
        msg_hash.merge( key => err.generate_message( field_name, @validator.kind ) )
      end

      puts 'msg_hash = ' << msg_hash.inspect
      msg_hash
    end

    def validation_rules( model, field_name, validators )
      rules_hash = {}
      @model, @field_name = model, field_name

      validators.each do |validator|
        @validator = validator
        val_method = @validator.class.name.split('::').last.underscore

        result = send( val_method ) if respond_to? val_method
        rules_hash.merge!( result ) unless result.nil?
      end

      puts 'rules_hash = ' << rules_hash.inspect
      rules_hash
    end

  end
end
