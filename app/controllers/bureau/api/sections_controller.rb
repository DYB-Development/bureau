module Bureau
  module Api
    class SectionsController < Bureau::ApplicationController
      def index
        render json: available_sections.map { |section| { key: section.key, actions: section.actions.keys } }
      end

      def update
        result = requested_action.new(person: current_person, account: account_settings_act_on, values: submitted_values).call

        render json: { ok: result.ok?, message: result.message }
      end

      private

      def requested_action
        section.actions[params[:action_name].to_sym]
      end

      def section
        Bureau.registry.find(params[:key])
      end

      def submitted_values
        params.except(:controller, :action, :key, :action_name).permit!.to_h.symbolize_keys
      end

      def available_sections
        visible_areas.values.flatten
      end
    end
  end
end
