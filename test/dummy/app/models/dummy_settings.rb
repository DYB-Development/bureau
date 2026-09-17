# frozen_string_literal: true

class DummySettings
  def self.register
    Bureau.section :notifications, area: :user, title: "Notifications"
    Bureau.section :spoken_for, area: :user, title: "Spoken for", renders: "bureau/sections/profile", runs: "DummyRefusal"
    Bureau.section :nickname, area: :user, title: "Nickname", renders: "bureau/sections/profile", runs: "DummyRename"
  end
end
