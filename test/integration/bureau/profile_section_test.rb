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

    test "opening a section lists the sections beside it" do
      get "/bureau/profile", params: { signed_in_as: @person.id }

      assert_select "nav[aria-label=Settings] a", text: "Profile"
    end

    test "the section a person opened is marked in the list" do
      get "/bureau/profile", params: { signed_in_as: @person.id }

      assert_select "nav[aria-label=Settings] a[aria-current=page]", text: "Profile"
    end

    test "submitting a section the app registered runs the object that section names" do
      patch "/bureau/nickname", params: { signed_in_as: @person.id, name: "Renamed Person" }

      assert_equal "Renamed Person of the account settings act on", @person.reload.name
    end

    test "submitting a section that names no object is refused" do
      Bureau.section :nickname, area: :user, title: "Nickname", renders: "bureau/sections/profile"

      patch "/bureau/nickname", params: { signed_in_as: @person.id, name: "Renamed Person" }

      assert_response :unprocessable_content
    end

    test "the app is told after a section's object has run" do
      patch "/bureau/nickname", params: { signed_in_as: @person.id, name: "Renamed Person" }

      assert_equal "nickname:#{@person.id}", response.headers["X-Settings-Change"]
    end

    test "the app is not told when the submission was refused" do
      Bureau.section :spare, area: :user, title: "Spare", renders: "bureau/sections/profile"

      patch "/bureau/spare", params: { signed_in_as: @person.id, name: "Renamed Person" }

      assert_nil response.headers["X-Settings-Change"]
    end

    test "a person whose change is refused is shown the reason" do
      patch "/bureau/spoken_for", params: { signed_in_as: @person.id, name: "Renamed Person" }

      assert_select "body", text: /That name is spoken for/
    end

    test "a refused change does not tell the app a change was made" do
      patch "/bureau/spoken_for", params: { signed_in_as: @person.id, name: "Renamed Person" }

      assert_nil response.headers["X-Settings-Change"]
    end

    test "the profile section shows why a name the record will not take was refused" do
      patch "/bureau/profile", params: { signed_in_as: @person.id, name: "" }

      assert_select "body", text: /Name can't be blank/
    end

    test "opening a section that lives on another page goes to that page" do
      Bureau.section :team, area: :team, title: "Team", at: "/team/members"

      get "/bureau/team", params: { signed_in_as: @person.id }

      assert_redirected_to "/team/members"
    end

    test "submitting to a section that lives on another page is refused" do
      Bureau.section :team, area: :team, title: "Team", at: "/team/members"

      patch "/bureau/team", params: { signed_in_as: @person.id }

      assert_response :unprocessable_content
    end

    test "a section's template is given the person and where to submit" do
      get "/bureau/from_elsewhere", params: { signed_in_as: @person.id, looking_at: "a-person" }

      assert_select "#from-elsewhere", text: "Shown to Pretend Person in the account settings act on, submitting to /bureau/from_elsewhere, looking at a-person"
    end

    test "a section with named actions submits each form to its own address" do
      get "/bureau/team", params: { signed_in_as: @person.id }

      assert_select "form#invite[action=?]", "/bureau/team/invite"
    end

    test "submitting a named action runs the object that action names" do
      patch "/bureau/team/invite", params: { signed_in_as: @person.id, email: "pretend@example.com" }

      assert_equal "Pretend Person invited pretend@example.com", @person.reload.name
    end

    test "submitting an action a section does not name is refused" do
      patch "/bureau/team/pretend", params: { signed_in_as: @person.id }

      assert_response :unprocessable_content
    end
  end
end
