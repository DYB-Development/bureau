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
  end
end
