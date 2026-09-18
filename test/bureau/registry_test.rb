require "test_helper"

module Bureau
  class RegistryTest < ActiveSupport::TestCase
    test "a different section claiming a key already taken in its area is refused" do
      registry = Registry.new
      registry.add(Section.new(key: :profile, area: :user, title: "Profile"))

      assert_raises(BadRegistration) do
        registry.add(Section.new(key: :profile, area: :user, title: "Something else"))
      end
    end

    test "a section that says it replaces the one already registered takes its place" do
      registry = Registry.new
      registry.add(Section.new(key: :profile, area: :user, title: "Profile"))

      registry.replace(Section.new(key: :profile, area: :user, title: "Something else"))

      assert_equal "Something else", registry.find(:profile).title
    end
  end
end
