# Include hook code here

# Primero requerimos Serenity
require 'serenity'
ActiveRecord::Base.send(:include, Serenity::Generator)

# Y ahora hobo_serenity.
require 'hobo-serenity'
ActiveRecord::Base.send(:include, HoboSerenity)


