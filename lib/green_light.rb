require 'active_model'
require 'active_support/all'

module GreenLight #:nodoc:
  require_relative 'green_light/rules'

  class Config
    class << self
      attr_accessor :models, :url_uniqueness_validator,
        :output_dir, :output_file, :output_var

      @models = []
      @url_uniqueness_validator = '/green_light/validate_unique'
      @output_dir = 'app/assets/javascripts/green_light'
      @output_file = 'validations.js'
      @output_var = 'GreenLight.validations'
    end
  end
end
