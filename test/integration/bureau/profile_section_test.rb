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
  end
end
