require "test_helper"

module Bureau
  class ApiSectionsTest < ActionDispatch::IntegrationTest
    setup do
      Bureau.prepare!
      DummySettings.register
      @person = ::Person.create!(name: "Pretend Person")
    end

    teardown { Bureau.prepare! }

    test "a caller asks for the sections available to it" do
      get "/bureau/api/sections", params: { signed_in_as: @person.id }

      assert_includes JSON.parse(response.body).map { |section| section["key"] }, "profile"
    end

    test "a caller is not given a section the person may not see" do
      Bureau.replace_section :team, area: :team, title: "Team", capability: :manage_team

      get "/bureau/api/sections", params: { signed_in_as: @person.id }

      assert_not_includes JSON.parse(response.body).map { |section| section["key"] }, "team"
    end

    test "a section names the actions it offers" do
      get "/bureau/api/sections", params: { signed_in_as: @person.id }

      assert_equal %w[invite rename], section_named("team")["actions"]
    end

    test "a caller runs an action and is told it succeeded" do
      patch "/bureau/api/sections/nickname/nickname", params: { signed_in_as: @person.id, name: "Renamed Person" }

      assert JSON.parse(response.body)["ok"]
    end

    private

    def section_named(key)
      JSON.parse(response.body).find { |section| section["key"] == key }
    end
  end
end
