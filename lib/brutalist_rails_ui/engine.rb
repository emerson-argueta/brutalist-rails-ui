module BrutalistRailsUi
  class Engine < ::Rails::Engine
    isolate_namespace BrutalistRailsUi

    initializer "brutalist_rails_ui.helpers" do
      ActiveSupport.on_load(:action_view) do
        include BrutalistRailsUi::Helpers
      end
    end
  end
end
