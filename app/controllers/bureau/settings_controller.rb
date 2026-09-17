module Bureau
  class SettingsController < ApplicationController
    def show
      @areas = Bureau.registry.areas
        .transform_values { |sections| sections.select { |section| allowed?(section) } }
        .reject { |_area, sections| sections.empty? }
    end
  end
end
