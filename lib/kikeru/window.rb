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

    def load
      stop
      @playbin.uri = Gst.filename_to_uri(@file)
      self.title = File.basename(@file)
      play
    end

    private
    def setup
      setup_window
      setup_gst
    end

    def setup_window
      signal_connect("destroy") do
        stop
        Gtk.main_quit
      end

      signal_connect("key_press_event") do |widget, event|
        case event.keyval
        when Gdk::Keyval::GDK_KEY_n
          @file = @container.shift(@file)
          load
        when Gdk::Keyval::GDK_KEY_p
          @file = @container.pop(@file)
          load
        when Gdk::Keyval::GDK_KEY_r
          load
        when Gdk::Keyval::GDK_KEY_q
          stop
          Gtk.main_quit
        when Gdk::Keyval::GDK_KEY_space
          toggle
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

      @playbin.bus.add_watch do |bus, message|
        case message.type
        when Gst::MessageType::EOS
          @file = @container.shift(@file)
          load
        end
        true
      end
    end

    def play
      @playbin.play
      @playing = true
    end

    def pause
      @playbin.pause
      @playing = false
    end

    def stop
      @playbin.stop
      @playing = false
    end

    def toggle
      @playing ? pause : play
    end
  end
end
