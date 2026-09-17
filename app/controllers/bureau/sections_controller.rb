module Bureau
  class SectionsController < ApplicationController
    before_action :set_section

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
  end
end
