require "kikeru/window"

class WindowTest < Test::Unit::TestCase
  def setup
    @window = Kikeru::Window.new
  end

  def test_add_container
    container = %w(a, b, c)
    mock(container).shift { "a" }
    @window.add_container(container)
  end
end
