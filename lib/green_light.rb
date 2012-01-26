require 'active_support/all'
require File.join(File.dirname(__FILE__), 'green_light/engine')

module GreenLight
  autoload :Rules, 'green_light/rules'
  module Translations
    autoload :JQueryValidate, 'green_light/translations/jquery_validate'
  end
end
