require 'awesome_print'
require 'active_support/all'
require_relative 'translations/jquery_validate'

class GreenLight::JSON
  extend GreenLight::Translations::JQueryValidate

  attr_reader :rules, :messages


  def self.rules
    generate
    @rules
  end

  def self.messages
    generate
    @messages
  end

  def self.combined
    generate
    { rules: @rules, messages: @messages }.to_json
  end


  private

  def self.generate( models=nil )
    @rules, @messages = {}, {}
    models ||= GreenLight::Config.models

    models.each do |model|
      model.constantize._validators.each do |field, validators|
        @rules.merge!( validation_rules( model, field, validators ) )
        @messages.merge!( error_messages( model, field, validators ) )
      end
    end
  end

  def self.validation_rules( model, field, validators )
    @model, @field = model, field
    rules_hash = { key => {} }

    validators.each do |validator|
      @validator = validator
      val_method = @validator.class.name.split('::').last.underscore
      result = send( val_method ) if respond_to? val_method
      rules_hash[key].merge!( result ) unless result.nil?
    end

    rules_hash
  end

  def self.error_messages( model, field, validators )
    msg_hash = {}
    @model, @field = model, field

    validators.each do |validator|
      @validator = validator
      err = ActiveModel::Errors.new( model.constantize.new )
      result = { key => err.generate_message( field, error_type_map( @validator.kind )) }
      msg_hash.merge!( result )
    end

    msg_hash
  end

  def self.error_type_map( validator_kind )
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
