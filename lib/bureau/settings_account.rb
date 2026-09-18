module Bureau
  module SettingsAccount
    def self.of(controller)
      return controller.settings_account if controller.respond_to?(:settings_account, true)

      controller.current_account
    end
  end
end
