require "test_helper"
require "rails/generators/test_case"
require "generators/bureau/section/section_generator"

module Bureau
  class SectionGeneratorTest < Rails::Generators::TestCase
    tests Bureau::Generators::SectionGenerator
    destination File.expand_path("../../tmp/generators", __dir__)
    setup :prepare_destination

    test "it registers the section" do
      run_generator %w[notifications]

      assert_file "config/initializers/bureau.rb", /Bureau\.section :notifications/
    end
  end
end
