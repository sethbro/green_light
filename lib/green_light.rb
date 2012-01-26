require 'active_model'
require 'active_support/all'

module GreenLight #:nodoc:
  require_relative 'green_light/rules'

  class Config
    class << self
      attr_accessor :models, :url_uniqueness_validator

      @models = []
      @url_uniqueness_validator = '/green_light/validate_unique'
    end
  end
end
