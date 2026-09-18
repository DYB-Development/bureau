# frozen_string_literal: true

require "test_helper"

module Bureau
  class SettingsPageTest < ActionDispatch::IntegrationTest
    setup do
      Bureau.reset!
      DummySettings.register
    end

    teardown { Bureau.reset! }

    test "the settings page renders inside the app's own layout" do
      get "/bureau"

      assert_select "title", text: "Dummy"
    end

    test "the settings page names itself" do
      get "/bureau"

      assert_select "h1", text: "Settings"
    end

    test "the settings page lists a section registered under the user area" do
      Bureau.replace_section :profile, area: :user, title: "Profile"

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

    test "a section whose capability the person does not hold is not listed" do
      Bureau.replace_section :team, area: :team, title: "Team", capability: :manage_team

      get "/bureau"

      assert_select "section[aria-label=Team] a", text: "Team", count: 0
    end

    test "a section registered with an address elsewhere links to that address" do
      Bureau.replace_section :team, area: :team, title: "Team", at: "/team/members"

      get "/bureau"

      assert_select "nav[aria-label=Settings] a[href=?]", "/team/members", text: "Team"
    end

    test "a section that lives on another page is hidden from a person without its capability" do
      Bureau.replace_section :team, area: :team, title: "Team", at: "/team/members", capability: :manage_team

      get "/bureau"

      assert_select "nav[aria-label=Settings] a", text: "Team", count: 0
    end

    test "a person who is not signed in gets the app's own answer" do
      get "/bureau", params: { signed_in: "no" }

      assert_redirected_to "/sign_in"
    end
  end
end
