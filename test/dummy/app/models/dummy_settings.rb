# frozen_string_literal: true

class DummySettings
  def self.register
    Bureau.section :notifications, area: :user, title: "Notifications"
  end
end
