module Bureau
  class ApplicationController < ::ApplicationController
    helper KeystoneUiHelper, Bureau::Engine.routes.url_helpers, Bureau::AppRoutesHelper

    before_action { Bureau::AppRoutesHelper.define_app_route_helpers }

    private

    def account_settings_act_on
      return settings_account if respond_to?(:settings_account, true)
      return current_account if respond_to?(:current_account, true)

      nil
    end

    def visible_areas
      Bureau.registry.areas
        .transform_values { |sections| sections.select { |section| allowed?(section) } }
        .reject { |_area, sections| sections.empty? }
    end

    def allowed?(section)
      section.capability.nil? || can?(section.capability)
    end
  end
end
