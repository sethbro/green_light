require 'awesome_print'
require_relative 'translations/jquery_validate'

module GreenLight
  class Rules
    include ::GreenLight::Translations::JQueryValidate

    attr_reader :rules, :messages

    def initialize( models=nil )
      @rules, @messages = {}, {}
      models ||= ::GreenLight::Config.models

      models.each do |model|
        model.constantize._validators.each do |field_name, validators|
          @rules.merge!( validation_rules( model, field_name, validators ) )
          @messages.merge!( error_messages( model, field_name, validators ) )
        end
      end
    end

    def to_json
      { rules: @rules, messages: @messages }.to_json
    end


    private

    def validation_rules( model, field_name, validators )
      @model, @field_name = model, field_name
      rules_hash = { key => {} }

      validators.each do |validator|
        @validator = validator
        val_method = @validator.class.name.split('::').last.underscore
        result = send( val_method ) if respond_to? val_method
        rules_hash[key].merge!( result ) unless result.nil?
      end

      rules_hash
    end

    def error_messages( model, field_name, validators )
      msg_hash = {}
      @model, @field_name = model, field_name

      validators.each do |validator|
        @validator = validator
        err = ActiveModel::Errors.new( model.constantize.new )
        result = { key => err.generate_message( field_name, error_type_map( @validator.kind )) }
        msg_hash.merge!( result )
      end

      msg_hash
    end

    def error_type_map( validator_kind )
      case validator_kind
      when :presence
        :blank
      when :length
        :too_short
      when :format
        :invalid
      when :numericality
        :not_a_number
      when :uniqueness
        :taken
      end
    end

  end
end
