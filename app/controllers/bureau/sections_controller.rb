module Bureau
  class SectionsController < ApplicationController
    def show
      @section = Bureau.registry.find(params[:key])
      @person = current_person

      render partial: @section.renders
    end

    def update
      ChangeName.new(person: current_person, name: params[:name]).call

      redirect_to section_path(params[:key])
    end
  end
end
