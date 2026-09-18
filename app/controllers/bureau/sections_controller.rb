module Bureau
  class SectionsController < ApplicationController
    before_action :set_section
    before_action :refuse_without_capability

    def show
      return redirect_to @section.at if @section.at

      @person = current_person
      @account = current_account_for_settings
      @areas = visible_areas

      render template: "bureau/settings/show"
    end

    def update
      return head :unprocessable_content unless @section.action

      result = @section.action.new(person: current_person, account: current_account_for_settings, values: submitted_values).call
      return show_refusal(result.message) unless result.ok?

      tell_the_app_it_ran

      redirect_to section_path(params[:key])
    end

    private

    def current_account_for_settings
      respond_to?(:current_account, true) ? current_account : nil
    end

    def show_refusal(message)
      @person = current_person
      @account = current_account_for_settings
      @areas = visible_areas
      @refusal = message

      render template: "bureau/settings/show", status: :unprocessable_content
    end

    def tell_the_app_it_ran
      return unless respond_to?(:after_settings_change, true)

      after_settings_change(section: @section, person: current_person)
    end

    def submitted_values
      params.except(:controller, :action, :key, :signed_in_as).permit!.to_h.symbolize_keys
    end

    def set_section
      @section = Bureau.registry.find(params[:key])

      raise ActionController::RoutingError, "No settings section named #{params[:key]}" unless @section
    end

    def refuse_without_capability
      head :forbidden unless allowed?(@section)
    end
  end
end
