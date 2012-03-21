require 'rails/generators'
require 'rails/generators/base'


module ManybotsGardener
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../../templates", __FILE__)
      
      class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true

      desc 'Mounts Manybots Gardener at "/manybots-weather"'
      def add_manybots_gardener_routes
        route 'mount ManybotsGardener::Engine => "/manybots-gardener"' if options.routes?
      end
      
      desc "Creates a ManybotsGardener initializer"
      def copy_initializer
        template "manybots-gardener.rb", "config/initializers/manybots-gardener.rb"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
      
    end
  end
end
