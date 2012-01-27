# Green Light

Translates validation logic & error messaging from your Rails/ActiveModel classes into a javascript object ready for use in the (jQuery Validation plugin)[http://bassistance.de/jquery-plugins/jquery-plugin-validation/]


## Installation

Add green_light to your Gemfile and run the <tt>bundle install</tt> command.

  gem 'green_light', :git => 'git://github.com/sethbro/green_light'


## Usage

Include jQuery & the jQuery validation plugin, either in your manifest file (<tt>app/assets/javascripts/application.js</tt>) or elsewhere.

In a config file at <tt>config/initializers/green_light.rb</tt>.
* Specify which models you want to generate client-side validation rules for.
  <pre>GreenLight::Config.models = ['ModelName1', 'ModelName2']</pre>

* Specify what directory you want the javascript output to:
  <pre>GreenLight::Config.output_dir = 'assets/javascripts/green_light/validations'</pre>

* Specify what javascript variable the validations should be assigned to:
  <pre>GreenLight::Config.output_var = 'GreenLight.Validations'

* Generate the javascript file via the rake task <b>green_light:update_validations</b>.

* In a DOMready call, call the validate method on forms you want validated.
<pre>$( 'form.green_light' ).validate(

Finally, add validations to your models!


## Currently supports these validations

  validates_presence_of
  validates_length_of
  validates_format_of
  validates_numericality_of

For validations that are not yet supported, the gem will degrade gracefully to the standard Rails server-side validation.


## Requirements

GreenLight works with any ActiveModel-based class.

Currently relies on the {jQuery Validation plugin}[http://bassistance.de/jquery-plugins/jquery-plugin-validation/]. This obviously means you need jQuery as well.


## Running Tests

  bundle install
  ruby spec/green_light_spec.rb
