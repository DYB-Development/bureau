module Bureau
  class Section
    attr_reader :key, :area, :title, :renders, :capability

    def initialize(key:, area:, title:, renders: nil, capability: nil)
      @key = key.to_sym
      @area = area.to_sym
      @title = title
      @renders = renders
      @capability = capability
    end
  end
end
