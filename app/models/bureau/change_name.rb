module Bureau
  class ChangeName
    def initialize(person:, name:)
      @person = person
      @name = name
    end

    def call
      @person.update(name: @name)
    end
  end
end
