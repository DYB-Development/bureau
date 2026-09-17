require "keystone_ui"

require "bureau/version"
require "bureau/engine"
require "bureau/registry"
require "bureau/section"
require "bureau/result"

module Bureau
  def self.registry
    @registry ||= Registry.new
  end

  def self.section(key, area:, title:, renders: nil, capability: nil, runs: nil, at: nil)
    registry.add(Section.new(key: key, area: area, title: title, renders: renders, capability: capability, runs: runs, at: at))
  end

  def self.reset!
    @registry = nil
    register_own_sections
  end

  def self.register_own_sections
    section :profile, area: :user, title: "Profile", renders: "bureau/sections/profile", runs: "Bureau::ChangeName"
  end
end
