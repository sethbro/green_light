require 'rubygems'
gem 'minitest'
#require 'rails'
require 'active_model'
require 'minitest/autorun'
require_relative '../lib/green_light'

describe GreenLight do

  let :key do
    'test_model[name]'
  end

  let :messages do
    { presence: %{can't be blank} }
  end

  let :rules do
    { presence: { presence: true } }
  end

  before :each do
    GreenLight::Config.models = [ 'TestModel' ]
  end


  it 'should generate an empty object if no models' do
    GreenLight::Config.models = []
    GreenLight::Rules.new.generate().must_equal( {}.to_json )
  end

  it 'should generate a json' do
    TestModel.validates_presence_of :name

    GreenLight::Rules.new.generate().must_equal( json( :presence ) )
  end

end

def json( validation )
  puts rules[validation]
  puts messages[validation]

  { key => rules[validation].merge( messages[validation] ) }.to_json.html_safe
end

def msg( validation )
  messages[validation]
end

class TestModel
  include ActiveModel::Validations
  attr_accessor :name
end
