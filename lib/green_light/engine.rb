module GreenLight #:nodoc:

  class Configuration
    self << class
      models = []
      url_uniqueness_validator = '/green_light/validate_unique'
    end
  end

  class Engine < ::Rails::Engine #:nodoc:
  # Enabling assets precompiling under rails 3.1
    if Rails.version >= '3.1'
      initializer :assets do |config|
        Rails.application.config.assets.precompile += %w( vendor/green_light/validations.js )
      end
    end
  end

end
