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

      get "/bureau"

      assert_select "nav[aria-label=Settings] a", text: "Profile"
    end

    test "a section the app registers is listed" do
      get "/bureau"

      assert_select "nav[aria-label=Settings] a", text: "Notifications"
    end

    test "a section in another area is listed under its own heading" do
      Bureau.section :members, area: :team, title: "Team"

      get "/bureau"

      assert_select "section[aria-label=Team] a", text: "Team"
    end

    test "the settings page links a section to its own page" do
      get "/bureau"

      assert_select "nav[aria-label=Settings] a[href=?]", "/bureau/profile"
    end

    test "a person who is not signed in gets the app's own answer" do
      get "/bureau", params: { signed_in: "no" }

      assert_redirected_to "/sign_in"
    end
  end
end
