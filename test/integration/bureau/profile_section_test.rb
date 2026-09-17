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
      get "/bureau/settings/profile", params: { person_id: @person.id }

      assert_select "input[name='name'][value=?]", "Pretend Person"
    end

    test "the profile section shows the new name a person submits" do
      patch "/bureau/settings/profile", params: { person_id: @person.id, name: "Renamed Person" }

      get "/bureau/settings/profile", params: { person_id: @person.id }

      assert_select "input[name='name'][value=?]", "Renamed Person"
    end
  end
end
