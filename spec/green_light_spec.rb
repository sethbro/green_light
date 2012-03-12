require_relative './spec_helper'

describe GreenLight do

  let(:key) { 'test_model[name]' }

  before :each do
    GreenLight::Config.models = %w(TestModel)
  end

  after :each do
    TestModel._validators.reject! {|k,v| true }
  end


  it 'defaults to models from config' do
    skip 'add mocha for stubbing'
  end

  it 'generates empty objects if no models' do
    GreenLight::Config.models = []
    blank_json = { rules: {}, messages: {} }.to_json
    GreenLight::JSON.combined.must_equal( blank_json )
  end

  it 'has a rules and messages component' do
    rules.wont_be_nil
    messages.wont_be_nil
  end

  it 'formats key using model and field name' do
    class TestModel
      validates_presence_of :name
    end

    rules[key].wont_be_nil
  end

  it 'processes multiple fields' do
    class TestModel
      validates_presence_of :name
      validates_presence_of :number
    end

    rule_for( :name )[:required].must_be_same_as true
    rule_for( :number )[:required].must_be_same_as true
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

  it 'does not return rules for unsupported validation types' do
    class TestModel
      validates_acceptance_of :name
    end

    rule_for( :name ).must_equal( {} )
  end

end
