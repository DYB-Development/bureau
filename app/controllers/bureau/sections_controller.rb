module Bureau
  class SectionsController < ApplicationController
    def show
      @section = Bureau.registry.find(params[:key])
      @person = current_person

      render partial: @section.renders
    end

    def update
      current_person.update(name: params[:name])

      redirect_to section_path(params[:key])
    end
  end
end
