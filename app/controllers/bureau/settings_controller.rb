module Bureau
  class SettingsController < ApplicationController
    def show
      @areas = visible_areas
    end
  end
end
