require "test_helper"

class LocalsTest < ActiveSupport::TestCase
  test "bureau ships a local for each of info, install and develop" do
    assert_equal %w[bureau-develop bureau-info bureau-install], local_names
  end

  private

  def local_names
    Dir[Bureau::Engine.root.join("the_local/agents/*.md")].map { |path| File.basename(path, ".md") }.sort
  end
end
