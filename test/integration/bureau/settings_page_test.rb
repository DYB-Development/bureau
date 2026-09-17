# frozen_string_literal: true

require "test_helper"

module Bureau
  class SettingsPageTest < ActionDispatch::IntegrationTest
    setup { Bureau.reset! }

    teardown { Bureau.reset! }

    test "the settings page lists a section registered under the user area" do
      Bureau.section :profile, area: :user, title: "Profile"

      get "/bureau/settings"

      assert_select "nav[aria-label=Settings] a", text: "Profile"
    end
  end
end
