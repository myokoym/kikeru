require "gtk3"
require "gst"

module Kikeru
  class Window < Gtk::Window
    def initialize
      super
      setup
    end

    def add_container(container)
      @container = container
      @file = @container.shift
    end

    def play
      @playbin.stop
      @playbin.uri = Gst.filename_to_uri(@file)
      self.title = File.basename(@file)
      @playbin.play
    end

    private
    def setup
      setup_window
      setup_gst
    end

    def setup_window
      signal_connect("destroy") do
        @playbin.stop
        Gtk.main_quit
      end

      signal_connect("key_press_event") do |widget, event|
        case event.keyval
        when Gdk::Keyval::GDK_KEY_n
          @file = @container.shift(@file)
          play
        when Gdk::Keyval::GDK_KEY_p
          @file = @container.pop(@file)
          play
        when Gdk::Keyval::GDK_KEY_r
          play
        when Gdk::Keyval::GDK_KEY_q
          @playbin.stop
          Gtk.main_quit
        end
      end
    end

    def setup_gst
      Gst.init

      @playbin = Gst::ElementFactory.make("playbin")
      if @playbin.nil?
        puts "'playbin' gstreamer plugin missing"
        exit(false)
      end
    end
  end
end
