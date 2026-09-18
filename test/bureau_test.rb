require "test_helper"

class BureauTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Bureau::VERSION
  end

  test "preparing the registrations again, as a code reload does, is not refused" do
    Bureau.prepare!

    assert_nothing_raised { Bureau.prepare! }
  ensure
    Bureau.prepare!
  end

  test "replacing a section puts the new one in the registry" do
    Bureau.prepare!
    Bureau.replace_section :profile, area: :user, title: "Renamed profile"

    assert_equal "Renamed profile", Bureau.registry.find(:profile).title
  ensure
    Bureau.prepare!
  end
end
