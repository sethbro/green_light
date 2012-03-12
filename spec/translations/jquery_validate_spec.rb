require_relative '../spec_helper'

describe GreenLight::Translations::JQueryValidate do

  let(:min) { 3 }
  let(:max) { 5 }
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
    TestModel._validators.reject! {|k,v| true }
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
