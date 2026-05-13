require "rails/generators"

module BrutalistRailsUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Installs BrutalistRailsUi CSS and Stimulus modal controller"

      def copy_css
        copy_file "brutalist_rails_ui.css", "app/assets/tailwind/brutalist_rails_ui.css"
        inject_into_file "app/assets/tailwind/application.css",
          %(@import "./brutalist_rails_ui";\n),
          after: %(@import "tailwindcss";\n)
      rescue Thor::Error
        say_status :skip, "Could not inject import — add '@import \"./brutalist_rails_ui\";' to app/assets/tailwind/application.css manually", :yellow
      end

      def copy_modal_controller
        copy_file "modal_controller.js", "app/javascript/controllers/modal_controller.js"
      end

      def done
        say ""
        say "BrutalistRailsUi installed!", :green
        say ""
        say "  1. Rebuild Tailwind:  bin/rails tailwindcss:build"
        say "  2. Add modal to your layout's importmap (if using importmap-rails):"
        say "       \"controllers/modal_controller\": asset_path('controllers/modal_controller.js')"
        say ""
      end
    end
  end
end
