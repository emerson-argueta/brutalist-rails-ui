module BrutalistRailsUi
  class Engine < ::Rails::Engine
    config.to_prepare do
      ActionView::Base.include BrutalistRailsUi::Helpers
    end
  end
end
