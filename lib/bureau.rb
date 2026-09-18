require "keystone_ui"

require "bureau/version"
require "bureau/engine"
require "bureau/bad_registration"
require "bureau/registry"
require "bureau/section"
require "bureau/result"
require "bureau/settings_account"

module Bureau
  def self.registry
    @registry ||= Registry.new
  end

  def self.section(key, **details)
    registry.add(Section.new(key: key, **details))
  end

  def self.replace_section(key, **details)
    registry.replace(Section.new(key: key, **details))
  end

  def self.reset!
    @registry = nil
    register_own_sections
  end

  def self.register_own_sections
    section :profile, area: :user, title: "Profile", renders: "bureau/sections/profile", runs: "Bureau::ChangeName"
  end
end
