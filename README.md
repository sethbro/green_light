# GreenLight

Translates validation logic & error messaging from your Rails/ActiveModel classes into a javascript object ready for use in the (jQuery Validation plugin)[http://bassistance.de/jquery-plugins/jquery-plugin-validation/]


## Installation

Add green_light to your Gemfile and run the <tt>bundle install</tt> command.

<pre>gem 'green_light', :git => 'git://github.com/sethbro/green_light'</pre>


## Usage

In a config file at <tt>config/initializers/green_light.rb</tt>.

* Specify which models you want to generate client-side validation rules for.
  <pre>GreenLight::Config.models = ['ModelName1', 'ModelName2']</pre>

* Specify what directory you want the javascript output to:
  <pre>GreenLight::Config.output_dir = 'app/assets/javascripts/green_light'</pre>

* Specify the name of the javascript output file:
  <pre>GreenLight::Config.output_file = 'validations.js'</pre>

* Specify what javascript variable the validations should be assigned to:
  <pre>GreenLight::Config.output_var = 'GreenLight.Validations'

* Generate the javascript file via rake task
  <pre>$ rake green_light:update_validations</pre>.

* On DOMready, call the jQuery.validate method on forms you want validated. E.g.
  <pre>$( 'form.green_light' ).validate( GreenLight.Validations )</pre>

Include jQuery & the jQuery validation plugin, either in your manifest file (<tt>app/assets/javascripts/application.js</tt>) or elsewhere.

Make sure your models include validations


## Currently supports these validations

  * validates_presence_of
  * validates_length_of
  * validates_format_of
  * validates_numericality_of (but not even/odd/float/integer or greater/less than)

For validations that are not yet supported, the gem degrades gracefully to use standard Rails server-side validation.


## Requirements

GreenLight works with any ActiveModel-based class.

Currently relies on the (jQuery Validation plugin)[http://bassistance.de/jquery-plugins/jquery-plugin-validation/]. This obviously means you need jQuery as well.


## Running Tests

<pre>$ ruby spec/green_light_spec.rb</pre>
