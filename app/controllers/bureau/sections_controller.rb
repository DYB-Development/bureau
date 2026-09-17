module Bureau
  class SectionsController < ApplicationController
    def show
      @section = Bureau.registry.find(params[:key])
      @person = current_person

      render partial: @section.renders
    end
  end
end
