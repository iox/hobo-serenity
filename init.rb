# First we include Serenity
require 'serenity'
ActiveRecord::Base.send(:include, Serenity::Generator)

# And now HoboSerenity
require 'hobo-serenity'
ActiveRecord::Base.send(:include, HoboSerenity)


