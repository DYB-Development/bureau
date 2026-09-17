require "keystone_ui"

require "bureau/version"
require "bureau/engine"
require "bureau/registry"
require "bureau/section"

module Bureau
  def self.registry
    @registry ||= Registry.new
  end

  def self.section(key, area:, title:, renders: nil, capability: nil)
    registry.add(Section.new(key: key, area: area, title: title, renders: renders, capability: capability))
  end

  def self.reset!
    @registry = nil
    register_own_sections
  end

  def self.register_own_sections
    section :profile, area: :user, title: "Profile", renders: "bureau/sections/profile"
  end
end
