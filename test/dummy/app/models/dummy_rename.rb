# frozen_string_literal: true

class DummyRename
  def initialize(person:, values:)
    @person = person
    @values = values
  end

  def call
    @person.update(name: "#{@values[:name]} of the dummy app")
  end
end
