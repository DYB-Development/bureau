# frozen_string_literal: true

require "test_helper"

module Bureau
  class ProfileSectionTest < ActionDispatch::IntegrationTest
    setup do
      Bureau.reset!
      DummySettings.register
      @person = ::Person.create!(name: "Pretend Person")
    end

    teardown { Bureau.reset! }

    test "the profile section shows the person's current name" do
      get "/bureau/profile", params: { signed_in_as: @person.id }

      assert_select "input[name='name'][value=?]", "Pretend Person"
    end

    test "the profile section shows the new name a person submits" do
      patch "/bureau/profile", params: { signed_in_as: @person.id, name: "Renamed Person" }

      get "/bureau/profile", params: { signed_in_as: @person.id }

      assert_select "input[name='name'][value=?]", "Renamed Person"
    end

    test "a person cannot rename another person by submitting their id" do
      other = ::Person.create!(name: "Other Person")

      patch "/bureau/profile?signed_in_as=#{@person.id}", params: { person_id: other.id, name: "Renamed Person" }

      assert_equal "Other Person", other.reload.name
    end

    test "a key no section is registered under is not found" do
      get "/bureau/nope", params: { signed_in_as: @person.id }

      assert_response :not_found
    end

    test "submitting to a key no section is registered under is not found" do
      patch "/bureau/nope", params: { signed_in_as: @person.id, name: "Renamed Person" }

      assert_response :not_found
    end

    test "opening a section without its capability is refused" do
      Bureau.section :team, area: :team, title: "Team", renders: "bureau/sections/profile", capability: :manage_team

      get "/bureau/team", params: { signed_in_as: @person.id }

      assert_response :forbidden
    end
  end
end
