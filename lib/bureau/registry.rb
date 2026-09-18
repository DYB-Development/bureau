module Bureau
  class Registry
    def initialize(capabilities: nil)
      @capabilities = capabilities
      @sections = []
    end

    def add(section)
      raise BadRegistration if taken_by_another(section)

      refuse_objects_the_app_cannot_find(section)
      refuse_capabilities_the_app_does_not_recognise(section)
      @sections << section
      section
    end

    def replace(section)
      @sections.delete(taken_by_another(section))
      @sections << section
      section
    end

    def refuse_objects_the_app_cannot_find(section)
      section.actions
    rescue NameError => missing
      raise BadRegistration, missing.message
    end

    def refuse_capabilities_the_app_does_not_recognise(section)
      return if section.capability.nil? || recognised_capabilities.nil?
      return if recognised_capabilities.map(&:to_sym).include?(section.capability.to_sym)

      raise BadRegistration
    end

    def recognised_capabilities
      declared = @capabilities || Bureau.capabilities
      declared.respond_to?(:call) ? declared.call : declared
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
