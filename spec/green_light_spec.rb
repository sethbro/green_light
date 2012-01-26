require 'rubygems'
require 'awesome_print'
gem 'minitest'
#require 'rails'
require 'active_model'
require 'minitest/autorun'
require_relative '../lib/green_light'

describe GreenLight do

  ap I18n.methods
  let(:min) { 3 }
  let(:max) { 7 }
  let(:format) { /wtf/ }

  let :key do
    'test_model[name]'
  end

  let :correct_messages do
    {
      presence: %{can't be blank},
      length: %{can't be blank},
    }
  end

  let :correct_rules do
    {
      presence: { presence: true }.to_json,
      length_min: { minlength: :min }.to_json,
      length_max: { maxlength: :max }.to_json,
      length_range: { minlength: :min, maxlength: :max }.to_json,
      numericality: { regex: '^[0-9]*$' }.to_json,
      format: { regex: :format }.to_json
    }
  end

  before :each do
    GreenLight::Config.models = [ 'TestModel' ]
  end

  it 'should default to models in config' do
  end

  it 'should generate an empty object if no models' do
    GreenLight::Config.models = []
    blank_json = { rules: {}, messages: {} }.to_json
    rules.must_equal( blank_json )
  end

  it 'should have a rules and messages component' do
    rules["rules"].wont_be_nil
    rules["messages"].wont_be_nil
  end

  it 'should format key using model and field name' do
    TestModel.validates_presence_of :name
    rules["rules"][key].wont_be_nil
  end

  it 'correctly returns presence validator rules' do
    TestModel.validates_presence_of :name
    rule_for( :name ).must_equal( correct_rules[:presence] )
  end

  # TODO: I18n is choking on missing %{count} interpolation value, so override messages
  it 'correctly returns length validator rules' do
    TestModel.validates_length_of :name, minimum: 3, too_long: 'long', too_short: 'short', wrong_length: 'wrong', message: 'wrong'
    rule_for( :name ).must_equal( correct_rules[:length_min] )
  end

  it 'correctly returns format validator rules' do
    TestModel.validates_format_of :name, with: :format
    rule_for( :name ).must_equal( correct_rules[:format] )
  end

  it 'correctly returns numeric validator rules' do
    TestModel.validates_numericality_of :number
    rule_for( :number ).must_equal( correct_rules[:numericality] )
  end

  it 'should process multiple fields' do
    TestModel.validates_presence_of :name
    TestModel.validates_presence_of :number

    rule_for( :name ).must_equal( correct_rules[:presence] )
    rule_for( :number ).must_equal( correct_rules[:presence] )
  end

  it 'should process multiple validation types on single field' do
    TestModel.validates_presence_of :name
    TestModel.validates_format_of :name, with: :format

    val_array = JSON.parse( rule_for( :name ) )
    val_array.must_be_instance_of Array
    val_array[:presence].must_be true
    val_array[:regex].wont_be_nil
  end

  it 'should process multiple models' do
  end

  it 'should not return rules for unsupported validation types' do
  end

end

def rules
  GreenLight::Rules.new.generate
end

def rule_for( field, opts={} )
  rules["rules"]["test_model[#{field.to_s}]"]
end

def message_for( field, opts={} )
  rules["messages"]["test_model[#{field.to_s}]"]
end

class TestModel
  include ActiveModel::Validations
  attr_accessor :name, :number, :format
end
