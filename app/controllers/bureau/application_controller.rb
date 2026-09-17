module Bureau
  class ApplicationController < ::ApplicationController
    helper KeystoneUiHelper

    private

    def allowed?(section)
      section.capability.nil? || can?(section.capability)
    end
  end
end
