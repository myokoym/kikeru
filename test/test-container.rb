require "kikeru/container"

class ContainerTest < Test::Unit::TestCase
  def setup
    @container = Kikeru::Container.new
  end

  def test_no_argument
    valid = @container.__send__(:file?, nil)
    assert_false(valid)
  end

  def test_missing_file
    valid = @container.__send__(:file?, "hoge")
    assert_false(valid)
  end
end
