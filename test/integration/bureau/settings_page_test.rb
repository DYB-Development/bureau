# frozen_string_literal: true

require "test_helper"

module Bureau
  class SettingsPageTest < ActionDispatch::IntegrationTest
    setup do
      Bureau.reset!
      DummySettings.register
    end

    teardown { Bureau.reset! }

    test "the settings page lists a section registered under the user area" do
      Bureau.section :profile, area: :user, title: "Profile"

      get "/bureau/settings"

      assert_select "nav[aria-label=Settings] a", text: "Profile"
    end

    test "a section the app registers is listed" do
      get "/bureau/settings"

      assert_select "nav[aria-label=Settings] a", text: "Notifications"
    end
  end
end
