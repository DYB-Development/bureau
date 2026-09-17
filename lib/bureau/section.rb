module Bureau
  class Section
    attr_reader :key, :area, :title

    def initialize(key:, area:, title:)
      @key = key.to_sym
      @area = area.to_sym
      @title = title
    end
  end
end
