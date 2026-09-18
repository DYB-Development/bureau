# frozen_string_literal: true

class DummySettings
  def self.register
    Bureau.section :notifications, area: :user, title: "Notifications"
    Bureau.section :from_elsewhere, area: :user, title: "From elsewhere", renders: "dummy_sections/from_elsewhere"
    Bureau.section :spoken_for, area: :user, title: "Spoken for", renders: "bureau/sections/profile", runs: "DummyRefusal"
    Bureau.section :team, area: :team, title: "Team", renders: "dummy_sections/team", runs: { invite: "DummyInvite", rename: "DummyRename" }
    Bureau.section :nickname, area: :user, title: "Nickname", renders: "bureau/sections/profile", runs: "DummyRename"
  end
end
