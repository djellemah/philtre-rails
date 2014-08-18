# http://api.rubyonrails.org/classes/Rails/Railtie.html
module PhiltreRails
  class Railtie < Rails::Railtie
    initializer "philtre-rails.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        send :define_method, :philtre_params do
          params[Philtre::Filter::Model.model_name.param_key.to_sym]
        end
      end
    end

    initializer "philtre-rails.configure_rails_initialization" do |app|
      # not sure about this?
      # Sequel.extension :core_extensions

      # and the code to do filtering and Sequel::Dataset manipulation
      require 'philtre.rb'
      require 'philtre/sequel_extensions.rb'
      require 'philtre_model.rb'
    end

    config.to_prepare do
      # Called once in production, on each request during development
      # Seems to be fine without it.
      # require 'philtre_model.rb'
    end

    initializer "philtre-rails.view_helpers" do
      require 'philtre-rails/order_link.rb'
      require 'philtre-rails/philtre_view_helpers.rb'
      ActionView::Base.send :include, PhiltreViewHelpers
    end
  end
end
