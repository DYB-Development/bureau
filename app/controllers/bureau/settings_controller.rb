module Bureau
  class SettingsController < ApplicationController
    def show
      @areas = Bureau.registry.areas
        .transform_values { |sections| sections.select { |section| allowed?(section) } }
        .reject { |_area, sections| sections.empty? }
    end

    private

    def allowed?(section)
      section.capability.nil? || can?(section.capability)
    end
  end
end
