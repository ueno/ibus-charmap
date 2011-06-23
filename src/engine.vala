// -*- mode: vala; indent-tabs-mode: nil -*-
// Copyright (C) 2011  Daiki Ueno
// Copyright (C) 2011  Red Hat, Inc.

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
// 02110-1301, USA.

namespace IBusGucharmap {
    class Engine : IBus.Engine {
        private static GLib.List<Engine> instances;
        private Gtk.Window charmap_window;
        private CharmapPanel charmap_panel;
        private int saved_x;
        private int saved_y;

        private const int INITIAL_WIDTH = 320;
        private const int INITIAL_HEIGHT = 240;

        struct MoveBinding {
            uint keyval;
            uint state;
            Gtk.MovementStep step;
            int count;
        }

        private const MoveBinding[] move_bindings = {
            { IBus.Up, 0, Gtk.MovementStep.DISPLAY_LINES, -1 },
            { IBus.KP_Up, 0, Gtk.MovementStep.DISPLAY_LINES, -1 },
            { IBus.Down, 0, Gtk.MovementStep.DISPLAY_LINES, 1 },
            { IBus.KP_Down, 0, Gtk.MovementStep.DISPLAY_LINES, 1 },
            { IBus.Home, 0, Gtk.MovementStep.BUFFER_ENDS, -1 },
            { IBus.KP_Home, 0, Gtk.MovementStep.BUFFER_ENDS, -1 },
            { IBus.End, 0, Gtk.MovementStep.BUFFER_ENDS, 1 },
            { IBus.KP_End, 0, Gtk.MovementStep.BUFFER_ENDS, 1 },
            { IBus.Page_Up, 0, Gtk.MovementStep.PAGES, -1 },
            { IBus.KP_Page_Up, 0, Gtk.MovementStep.PAGES, -1 },
            { IBus.Page_Down, 0, Gtk.MovementStep.PAGES, 1 },
            { IBus.KP_Page_Down, 0, Gtk.MovementStep.PAGES, 1 },
            { IBus.Left, 0, Gtk.MovementStep.VISUAL_POSITIONS, -1 },
            { IBus.KP_Left, 0, Gtk.MovementStep.VISUAL_POSITIONS, -1 },
            { IBus.Right, 0, Gtk.MovementStep.VISUAL_POSITIONS, 1 },
            { IBus.KP_Right, 0, Gtk.MovementStep.VISUAL_POSITIONS, 1 }
        };

        public override void enable () {
            show_charmap_window ();
        }

        public override void disable () {
            hide_charmap_window ();
        }
        
        public override void focus_in () {
            show_charmap_window ();
        }

        public override void focus_out () {
            hide_charmap_window ();
        }

        public override bool process_key_event (uint keyval,
                                                uint keycode,
                                                uint state)
        {
            // ignore release event
            if ((IBus.ModifierType.RELEASE_MASK & state) != 0)
                return false;

            // process chartable move bindings
            foreach (var binding in move_bindings) {
                if (binding.keyval == keyval && binding.state == state) {
                    charmap_panel.chartable.move_cursor (binding.step,
                                                         binding.count);
                    return true;
                }
            }

            // process return - activate current character in chartable
            if (keyval == IBus.Return && state == 0) {
                charmap_panel.chartable.activate ();
                return true;
            }

            // process alt+Down to popup the chapters combobox
            if ((IBus.ModifierType.MOD1_MASK & state) != 0 &&
                (keyval == IBus.Down || keyval == IBus.KP_Down)) {
                charmap_panel.chapters.popup ();
            }
            return false;
        }

        public override void destroy () {
            charmap_window.destroy ();
        }

        private void on_chartable_activate (Gucharmap.Chartable chartable) {
            var uc = chartable.get_active_character ();
            if (uc > 0)
                commit_text (new IBus.Text.from_string (uc.to_string ()));
        }

        construct {
            charmap_window = new Gtk.Window (Gtk.WindowType.POPUP);
            charmap_window.set_size_request (INITIAL_WIDTH,
                                                  INITIAL_HEIGHT);
            charmap_panel = new CharmapPanel ();
            charmap_panel.chartable.activate.connect (on_chartable_activate);
            charmap_window.add (charmap_panel);
            // Pass around "hide" signal to charmap panel, to tell
            // that the toplevel window is hidden - this is necessary
            // to clear zoom window (see CharmapPanel#on_hide()).
            charmap_window.hide.connect (() => charmap_panel.hide ());

            // Manually disable all other instances of this engine as
            // IBus 1.4 no longer destroy engines.
            foreach (var engine in instances) {
                engine.disable ();
            }
            instances.append (this);
        }

        private void show_charmap_window () {
            charmap_window.show_all ();
            if (saved_x >= 0 && saved_y >= 0)
                charmap_window.move (saved_x, saved_y);
        }

        private void hide_charmap_window () {
            if (charmap_window != null) {
                charmap_window.hide ();
            }
        }

        public override void set_cursor_location (int x, int y, int w, int h) {
            if (charmap_window == null)
                return;

            // TODO: More precise placement calculation
            Gtk.Allocation allocation;
            charmap_window.get_allocation (out allocation);

            int rx, ry, rw, rh;
            var root_window = Gdk.get_default_root_window ();
            root_window.get_geometry (out rx, out ry, out rw, out rh);

            if (x + allocation.width > rw)
                x -= allocation.width;
            x = int.max (x, rx);
            
            if (y + h + allocation.height > rh)
                y -= allocation.height;
            else
                y += h;
            y = int.max (y, ry);

            if ((x != saved_x || y != saved_y)) {
                charmap_window.move (x, y);
                saved_x = x;
                saved_y = y;
            }
        }
    }
}
