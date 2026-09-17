module Bureau
  class Section
    attr_reader :key, :area, :title, :renders, :capability, :runs, :at

    def initialize(key:, area:, title:, renders: nil, capability: nil, runs: nil, at: nil)
      @key = key.to_sym
      @area = area.to_sym
      @title = title
      @renders = renders
      @capability = capability
      @runs = runs
      @at = at
    end

    def action
      runs&.constantize
    end
  end
end
