module Bureau
  class ChangeName
    def initialize(person:, values:)
      @person = person
      @values = values
    end

    def call
      @person.update(name: @values[:name])
    end
  end
end
