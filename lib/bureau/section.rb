module Bureau
  class Section
    attr_reader :key, :area, :title, :renders

    def initialize(key:, area:, title:, renders: nil)
      @key = key.to_sym
      @area = area.to_sym
      @title = title
      @renders = renders
    end
  end
end
