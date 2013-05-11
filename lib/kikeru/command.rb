require "gtk3"
require "kikeru/version"
require "kikeru/logger"
require "kikeru/container"
require "kikeru/window"

module Kikeru
  class Command
    USAGE = "Usage: kikeru [OPTION]... [FILE]..."

    class << self
      def run(*arguments)
        new.run(arguments)
      end
    end

    def initialize
      @logger = Kikeru::Logger.new
    end

    def run(arguments)
      if /\A(-h|--help)\z/ =~ arguments[0]
        write_help_message
        exit(true)
      elsif /\A(-v|--version)\z/ =~ arguments[0]
        write_version_message
        exit(true)
      end

      files = files_from_arguments(arguments)
      file_container = Kikeru::Container.new(files)

      if file_container.empty?
        write_empty_message
        exit(false)
      end

      window = Kikeru::Window.new
      window.add_container(file_container)
      window.show_all
      window.load

      Gtk.main
    end

    private
    def files_from_arguments(arguments)
      if arguments.empty?
        files = Dir.glob("*")
      elsif purge_option(arguments, /\A(-d|--deep)\z/)
        if arguments.empty?
          files = Dir.glob("**/*")
        else
          files = []
          arguments.each do |f|
            if File.directory?(f)
              files << Dir.glob("#{f}/**/*")
            else
              files << f
            end
          end
          files.flatten!
        end
      elsif arguments.all? {|v| File.directory?(v) }
        files = []
        arguments.each do |f|
          files << Dir.glob("#{f}/*")
        end
        files.flatten!
      else
        files = arguments
      end
      files
    end

    def purge_option(arguments, regexp, has_value=false)
      index = arguments.find_index {|arg| regexp =~ arg }
      return false unless index
      if has_value
        arguments.delete_at(index) # flag
        arguments.delete_at(index) # value
      else
        arguments.delete_at(index)
      end
    end

    def write_help_message
      message = <<-EOM
#{USAGE}
  If no argument, then search current directory.
Options:
  -d, --deep
      deep search as "**/*"
Keybind:
  n: next
  p: prev
  r: restart
  q: quit
      EOM
      @logger.info(message)
    end

    def write_version_message
      message = <<-EOM
#{Kikeru::VERSION}
      EOM
      @logger.info(message)
    end

    def write_empty_message
      message = <<-EOM
Warning: file not found.
#{USAGE}
  If no argument, then search current directory.
Options:
  -d, --deep
      deep search as "**/*"
      EOM
      @logger.error(message)
    end
  end
end
