require "kikeru/logger"
require "stringio"

class LoggerTest < Test::Unit::TestCase
  def setup
    @logger = Kikeru::Logger.new
  end

  def test_info
    s = ""
    io = StringIO.new(s)
    $stdout = io
    message = <<-EOM
#{Kikeru::Command::USAGE}
  If no argument, then search current directory.
Keybind:
  n: next
  p: prev
  r: restart
  q: quit
    EOM
    @logger.info(message)
    $stdout = STDOUT
    assert_equal(message, s)
  end

  def test_error
    s = ""
    io = StringIO.new(s)
    $stderr = io
    message = <<-EOM
Warning: valid file not found.
#{Kikeru::Command::USAGE}
Support file types: png, gif, jpeg(jpg). The others are...yet.
    EOM
    @logger.error(message)
    $stderr = STDERR
    assert_equal(message, s)
  end
end
