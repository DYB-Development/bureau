# frozen_string_literal: true

class DummyRefusal
  def initialize(person:, values:)
    @person = person
    @values = values
  end

  def call
    Bureau::Result.refused("That name is spoken for")
  end
end
