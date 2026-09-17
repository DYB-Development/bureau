module Bureau
  class SectionsController < ApplicationController
    before_action :set_section
    before_action :refuse_without_capability

    def show
      @person = current_person

      render partial: @section.renders
    end

    def update
      ChangeName.new(person: current_person, name: params[:name]).call

      redirect_to section_path(params[:key])
    end

    private

    def set_section
      @section = Bureau.registry.find(params[:key])

      raise ActionController::RoutingError, "No settings section named #{params[:key]}" unless @section
    end

    def refuse_without_capability
      head :forbidden unless allowed?(@section)
    end
  end
end
