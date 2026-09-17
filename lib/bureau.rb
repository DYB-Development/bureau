require "keystone_ui"

require "bureau/version"
require "bureau/engine"
require "bureau/registry"
require "bureau/section"

module Bureau
  def self.registry
    @registry ||= Registry.new
  end

  def self.section(key, area:, title:)
    registry.add(Section.new(key: key, area: area, title: title))
  end

  def self.reset!
    @registry = nil
  end
end
