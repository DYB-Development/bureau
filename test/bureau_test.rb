require "test_helper"

class BureauTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Bureau::VERSION
  end

  test "replacing a section puts the new one in the registry" do
    Bureau.reset!
    Bureau.replace_section :profile, area: :user, title: "Renamed profile"

    assert_equal "Renamed profile", Bureau.registry.find(:profile).title
  ensure
    Bureau.reset!
  end
end
