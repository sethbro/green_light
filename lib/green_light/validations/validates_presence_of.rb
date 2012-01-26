module GreenLight
  module Translations

    def presence_validator(params = {})
      {:required => true}
    end

    def format_validator(params = {})
      {:regex => "#{params[:val_obj].options[:with]}".gsub('?-mix:', '')}
    end

  module Validations
    module ValidatesPresenceOf
      extend ActiveSupport::Concern

      module ClassMethods
        def presence_validator(params = {})
          {:required => true}
        end
      end
    end
  end
end

