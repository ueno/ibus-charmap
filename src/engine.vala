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

        private IBus.PropList prop_list;

        private Gtk.Window window;
        private int saved_x;
        private int saved_y;

        private Gtk.Container panel;
        private CharmapPanel charmap_panel;
        private SearchPanel search_panel;

        // const values
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
            show_window ();
        }

        public override void disable () {
            hide_window ();
        }
        
        public override void focus_in () {
            register_properties (prop_list);
            show_window ();
        }

        public override void focus_out () {
            hide_window ();
        }

        public override void property_activate (string prop_name,
                                                uint prop_state)
        {
            if (prop_name == "setup")
                Process.spawn_command_line_async ("%s/ibus-setup-gucharmap".printf (Config.LIBEXECDIR));
        }

        private void update_panel () {
            var current = window.get_child ();
            current.hide ();
            window.remove (current);
            panel.show_all ();
            window.add (panel);
            show_window ();
        }

        private static bool isascii (uint keyval) {
            return 0x20 <= keyval && keyval <= 0x7E;
        }

        private bool process_charmap_key_event (uint keyval,
                                                uint keycode,
                                                uint state)
        {
            // ignore release event
            if ((IBus.ModifierType.RELEASE_MASK & state) != 0)
                return false;

            // process chartable move bindings
            foreach (var binding in move_bindings) {
                if (binding.keyval == keyval && binding.state == state) {
                    charmap_panel.move_cursor (binding.step, binding.count);
                    return true;
                }
            }

            // process return - activate current character in chartable
            if (keyval == IBus.Return && state == 0) {
                charmap_panel.activate_selected ();
                return true;
            }

            // process alt+Down to popup the chapters combobox
            if ((IBus.ModifierType.MOD1_MASK & state) != 0 &&
                (keyval == IBus.Down || keyval == IBus.KP_Down)) {
                charmap_panel.popup_chapters ();
                return true;
            }

            if (state == 0 && isascii (keyval)) {
                char c = (char)keyval;
                search_panel.append_c (c);
                panel = search_panel;
                update_panel ();
                return true;
            }
                
            return true;
        }

        private bool process_search_key_event (uint keyval,
                                                uint keycode,
                                                uint state)
        {
            // ignore release event
            if ((IBus.ModifierType.RELEASE_MASK & state) != 0)
                return false;

            if (state == 0 && isascii (keyval)) {
                char c = (char)keyval;
                search_panel.append_c (c);
                return true;
            }

            if (keyval == IBus.BackSpace) {
                search_panel.delete_c ();
                if (search_panel.get_text ().length == 0) {
                    panel = charmap_panel;
                    update_panel ();
                }
                return true;
            }

            // process chartable move bindings
            foreach (var binding in move_bindings) {
                if (binding.keyval == keyval && binding.state == state) {
                    search_panel.move_cursor (binding.step, binding.count);
                    return true;
                }
            }

            if (keyval == IBus.Return) {
                search_panel.activate_selected ();
                return true;
            }

            if (keyval == IBus.Escape) {
                search_panel.erase ();
                panel = charmap_panel;
                update_panel ();
                return true;
            }
 
            return true;
        }

        public override bool process_key_event (uint keyval,
                                                uint keycode,
                                                uint state)
        {
            if (panel == charmap_panel)
                return process_charmap_key_event (keyval, keycode, state);
            else
                return process_search_key_event (keyval, keycode, state);
        }

        public override void destroy () {
            window.destroy ();
        }

        private void on_charmap_activate_character (unichar uc) {
            if (uc > 0)
                commit_text (new IBus.Text.from_string (uc.to_string ()));
        }

        private void on_search_activate_character (unichar uc) {
            search_panel.erase ();
            charmap_panel.activate_character (uc);
            panel = charmap_panel;
            update_panel ();
        }

        construct {
            window = new Gtk.Window (Gtk.WindowType.POPUP);
            window.set_size_request (INITIAL_WIDTH,
                                                  INITIAL_HEIGHT);
            charmap_panel = new CharmapPanel ();
            charmap_panel.activate_character.connect (
                on_charmap_activate_character);

            search_panel = new SearchPanel ();
            search_panel.activate_character.connect (
                on_search_activate_character);

            // The initial window state is charmap display.
            panel = charmap_panel;

            window.add (panel);

            // Pass around "hide" signal to charmap panel, to tell
            // that the toplevel window is hidden - this is necessary
            // to clear zoom window (see CharmapPanel#on_hide()).
            window.hide.connect (() => charmap_panel.hide ());

            // Manually disable all other instances of this engine as
            // IBus 1.4 no longer destroy engines.
            foreach (var engine in instances) {
                engine.disable ();
            }
            instances.append (this);

            prop_list = new IBus.PropList ();
            var prop = new IBus.Property ("setup",
                                          IBus.PropType.NORMAL,
                                          new IBus.Text.from_string ("Setup"),
                                          "gtk-preferences",
                                          new IBus.Text.from_string ("Configure Gucharmap engine"),
                                          true,
                                          true,
                                          IBus.PropState.UNCHECKED,
                                          null);
            prop_list.append (prop);
        }

        private void show_window () {
            window.show_all ();
            if (saved_x >= 0 && saved_y >= 0)
                window.move (saved_x, saved_y);
        }

        private void hide_window () {
            if (window != null) {
                window.hide ();
            }
        }

        public override void set_cursor_location (int x, int y, int w, int h) {
            if (window == null)
                return;

            // TODO: More precise placement calculation
            Gtk.Allocation allocation;
            window.get_allocation (out allocation);

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
                window.move (x, y);
                saved_x = x;
                saved_y = y;
            }
        }
    }
}
