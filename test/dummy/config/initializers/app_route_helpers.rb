# frozen_string_literal: true

ActiveSupport.on_load(:action_controller) do
  helper Rails.application.routes.url_helpers
end
