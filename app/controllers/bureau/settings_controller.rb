module Bureau
  class SettingsController < ApplicationController
    def show
      @areas = Bureau.registry.areas
    end
  end
end
