module Bureau
  class Registry
    def initialize
      @sections = []
    end

    def add(section)
      @sections.reject! { |existing| existing.key == section.key && existing.area == section.area }
      @sections << section
      section
    end

    def in_area(area)
      @sections.select { |section| section.area == area.to_sym }
    end

    def find(key)
      @sections.find { |section| section.key == key.to_sym }
    end

    def areas
      @sections.group_by(&:area)
    end
  end
end
