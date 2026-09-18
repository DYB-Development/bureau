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
  end
end
