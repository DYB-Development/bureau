module Bureau
  module Api
    class SectionsController < Bureau::ApplicationController
      def index
        render json: available_sections.map { |section| { key: section.key } }
      end

      private

      def available_sections
        visible_areas.values.flatten
      end
    end
  end
end
