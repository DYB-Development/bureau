module Bureau
  module SettingsAccount
    def self.of(controller)
      return controller.settings_account if controller.respond_to?(:settings_account, true)
      return controller.current_account if controller.respond_to?(:current_account, true)

      nil
    end
  end
end
