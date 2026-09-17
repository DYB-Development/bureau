module Bureau
  class Section
    attr_reader :key, :area, :title, :renders, :capability, :runs

    def initialize(key:, area:, title:, renders: nil, capability: nil, runs: nil)
      @key = key.to_sym
      @area = area.to_sym
      @title = title
      @renders = renders
      @capability = capability
      @runs = runs
    end

    def action
      runs&.constantize
    end
  end
end
