require 'rubygems'
gem 'minitest'
require 'awesome_print'
require 'minitest/autorun'
require 'active_model'
require_relative '../lib/green_light'

def rules
  GreenLight::JSON.rules
end

def messages
  GreenLight::JSON.messages
end

def rule_for( field, model='test_model', opts={} )
  rules["#{model}[#{field.to_s}]"]
end

def message_for( field, model='test_model', opts={} )
  messages["#{model}[#{field.to_s}]"]
end

class TestModel
  include ActiveModel::Validations
  attr_accessor :name, :number, :format
end

class OtherTestModel
  include ActiveModel::Validations
  attr_accessor :other_name, :other_number
end
