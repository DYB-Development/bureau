module Bureau
  class SectionsController < ApplicationController
    before_action :set_section
    before_action :refuse_without_capability

    def show
      @person = current_person
      @areas = visible_areas

      render template: "bureau/settings/show"
    end

    def update
      @section.action.new(person: current_person, values: submitted_values).call

      redirect_to section_path(params[:key])
    end

    private

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
