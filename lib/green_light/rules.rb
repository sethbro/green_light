module GreenLight
  class Rules
    include Translations::JQueryValidate

    def self.generate( models )
      rules, messages = {}, {}

      models.each do |model|

        model.constantize._validators.each do |field_name, validators|
          rules.merge( validation_rules( model, field_name, validators ) )
          messages.merge( error_messages( ( model, field_name, validators ) )
        end
      end

      data = "TC.GreenLight = #{data.to_json.html_safe}"
    end


    private

    def error_messages( model, field_name, validators )
      @model, @field_name, msg_hash = model, field_name, msg_hash

      validators.each do |validator|
        @validator = validator
        err = ActiveModel::Errors.new( model.constantize.new )
        msg_hash.merge( key => err.generate_message( field_name, @validator.kind ) )
      end
    end

    def validation_rules( model, field_name, validators )
      @model, @field_name, msg_hash = model, field_name, msg_hash

      validators.each do |validator|
        @validator = validator
        val_method = @validator.class.name.split('::').last.underscore

        result = send( val_method ) if respond_to? val_method
        rule_hash.merge!( result ) unless result.nil?
      end

      rule_hash
    end

  end
end
