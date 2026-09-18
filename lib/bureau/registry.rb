module Bureau
  class Registry
    def initialize
      @sections = []
    end

    def add(section)
      raise BadRegistration if taken_by_another(section)

      @sections << section
      section
    end

    def replace(section)
      @sections.delete(taken_by_another(section))
      @sections << section
      section
    end

    def taken_by_another(section)
      @sections.find { |existing| existing.key == section.key && existing.area == section.area }
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
