require 'rubygems'
require 'awesome_print'
gem 'minitest'
require 'active_model'
require 'minitest/autorun'
require_relative '../lib/green_light'

describe GreenLight do

  let(:min) { 3 }
  let(:max) { 5 }
  let(:regex) { /wtf/ }
  let(:format) { regex.to_s }
  let(:key) { 'test_model[name]' }

  let :correct_messages do
    {
      presence: %{can't be blank},
      length: %{can't be blank}
    }
  end

  let :correct_rules do
    {
      presence:     { required: true }.to_json.html_safe,
      length_min:   { minlength: min }.to_json,
      length_max:   { maxlength: max }.to_json,
      length_range: { minlength: min, maxlength: max }.to_json,
      numericality: { regex: '^[0-9]*$' }.to_json,
      format:       { regex: '(wtf)'}.to_json
    }
  end

  before :each do
    GreenLight::Config.models = %w(TestModel)
  end

  after :each do
    TestModel._validators.reject! {|k,v| ! v.nil? }
  end


  it 'defaults to models from config' do
    skip 'add mocha for stubbing'
  end

  it 'generates empty objects if no models' do
    GreenLight::Config.models = []
    blank_json = { rules: {}, messages: {} }.to_json
    rules.to_json.must_equal( blank_json )
  end

  it 'has a rules and messages component' do
    rules.rules.wont_be_nil
    rules.messages.wont_be_nil
  end

  it 'formats key using model and field name' do
    class TestModel
      validates_presence_of :name
    end

    rules.rules[key].wont_be_nil
  end

  it 'processes multiple fields' do
    class TestModel
      validates_presence_of :name
      validates_presence_of :number
    end

    rule_for( :name ).to_json.must_equal( correct_rules[:presence] )
    rule_for( :number ).to_json.must_equal( correct_rules[:presence] )
  end

  it 'processes multiple validation types for a single field' do
    class TestModel
      regex = /wtf/
      validates_presence_of :name
      validates_format_of :name, with: regex
    end

    validations = rule_for :name

    validations.must_be_instance_of Hash
    validations[:regex].must_equal( '(wtf)' )
    validations[:required].must_equal true
  end

  it 'processes multiple models' do
    class TestModel
      validates_presence_of :name
    end

    class OtherTestModel
      validates_presence_of :other_name
    end

    GreenLight::Config.models = %w(TestModel OtherTestModel)

     rule_for( :name ).must_be_instance_of Hash
     rule_for( :other_name, 'other_test_model' ).must_be_instance_of Hash
  end

  it ' not return rules for unsupported validation types' do
    class TestModel
      validates_acceptance_of :name
    end

    rule_for( :name ).must_equal( {} )
  end

  # Translation-specific
  it 'correctly returns presence validator rules' do
    class TestModel
      validates_presence_of :name
    end

    rule_for( :name ).to_json.must_equal( correct_rules[:presence] )
  end

  # TODO: I18n is choking on missing %{count} interpolation value, so override messages
  it 'correctly returns length validator rules' do
    skip 'I18n chokes on missing %{count} interpolation value'
    class TestModel
      min = 3
      validates_length_of :name, minimum: min, too_long: 'no', too_short: 'no', wrong_length: 'no'
    end

    rule_for( :name ).to_json.must_equal( correct_rules[:length_min] )
  end

  it 'correctly returns format validator rules' do
    class TestModel
      regex = /wtf/
      validates_format_of :name, with: regex
    end

    rule_for( :name ).to_json.must_equal( correct_rules[:format] )
  end

  it 'correctly returns numeric validator rules' do
    class TestModel
      validates_numericality_of :number
    end

    rule_for( :number ).to_json.must_equal( correct_rules[:numericality] )
  end

end


def rules
  GreenLight::Rules.new
end

def rule_for( field, model='test_model', opts={} )
  rules.rules["#{model}[#{field.to_s}]"]
end

def message_for( field, model='test_model', opts={} )
  rules.messages["[#{field.to_s}]"]
end

class TestModel
  include ActiveModel::Validations
  attr_accessor :name, :number, :format
end

class OtherTestModel
  include ActiveModel::Validations
  attr_accessor :other_name, :other_number
end
