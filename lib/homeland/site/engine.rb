# frozen_string_literal: true

module Homeland::Site
  class Engine < ::Rails::Engine
    isolate_namespace Homeland::Site

    initializer 'homeland.site.assets.precompile', group: :all do |app|
      app.config.assets.precompile += %w[homeland/site/application.css homeland/site/application.js]
    end

    initializer "homeland.site.init" do |app|
      next unless (defined? Setting) && Setting.has_module?(:site)
      Homeland.register_plugin do |plugin|
        plugin.name = Homeland::Site::NAME
        plugin.display_name = "酷站"
        plugin.version = Homeland::Site::VERSION
        plugin.description = Homeland::Site::DESCRIPTION
        plugin.navbar_link = true
        plugin.admin_navbar_link = true
        plugin.root_path = "/sites"
        plugin.admin_path = "/admin/sites"
      end

      app.routes.prepend do
        mount Homeland::Site::Engine => "/"
      end
      app.config.paths["db/migrate"].concat(config.paths["db/migrate"].expanded)
    end
  end
end
