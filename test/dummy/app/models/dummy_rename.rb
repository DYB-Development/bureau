# frozen_string_literal: true

class DummyRename
  def initialize(person:, account:, values:)
    @person = person
    @account = account
    @values = values
  end

  def call
    @person.update(name: "#{@values[:name]} of #{@account}")

    Bureau::Result.ok
  end
end
