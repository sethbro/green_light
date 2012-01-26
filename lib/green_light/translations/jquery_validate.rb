module GreenLight
  module Translations
    module JQueryValidate

      def key
        "#{@model.to_s.underscore.downcase}[#{@field_name}]"
      end

      def presence_validator
        { key => { :required => true } }
      end

      def format_validator
        { key => {:regex => "#{@validator.options[:with]}".gsub('?-mix:', '') }}
      end

      def numericality_validator
        { key => {:regex => "^[0-9]*$" }}
      end

      def length_validator
        length_hash = {}
        opts = @validator.options
        length_hash[:minlength] = opts[:minimum] if opts[:minimum]
        length_hash[:maxlength] = opts[:maximum] if opts[:maximum]
      end

      def uniqueness_validator
        params = [ "model=#{@model.to_s}", "field=#{@field_name}" ].join( '&' )
        { key => {
          :remote => "#{GreenLight.config.url_uniqueness_validator}?#{params}" } }
      end

    end
  end
end
