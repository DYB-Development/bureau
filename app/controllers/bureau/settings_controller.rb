module Bureau
  class SettingsController < ApplicationController
    def show
      @sections = Bureau.registry.in_area(:user)
    end
  end
end
