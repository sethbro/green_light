module GreenLight
  module Translations
    module JQueryValidate

      def key
        "#{@model.to_s.underscore.downcase}[#{@field}]"
      end

      def presence_validator
        { :required => true }
      end

      def format_validator
        {:regex => "#{@validator.options[:with]}".gsub('?-mix:', '') }
      end

      # TODO: Even/odd/float/integer/greater&lessthan
      def numericality_validator
        { digits: true }
      end

      def length_validator
        length = {}
        opts = @validator.options

        if opts[:is]
          length[:minlength] = opts[:is]
          length[:maxlength] = opts[:is]
        elsif range = opts[:within] || opts[:in]
          length[:minlength] = range.begin
          length[:maxlength] = range.end
        else
          length[:minlength] = opts[:minimum] if opts[:minimum]
          length[:maxlength] = opts[:maximum] if opts[:maximum]
        end

        length
      end

      #def uniqueness_validator
      #  params = [ "model=#{@model.to_s}", "field=#{@field_name}" ].join( '&' )
      #  {
      #    :remote => "#{GreenLight.config.url_uniqueness_validator}?#{params}" } }
      #end

    end
  end
end
