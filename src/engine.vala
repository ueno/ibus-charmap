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
        private int x = -1;
        private int y = -1;

        private const int INITIAL_WIDTH = 320;
        private const int INITIAL_HEIGHT = 240;

        private void on_charmap_select (unichar uc) {
            commit_text (new IBus.Text.from_string (uc.to_string ()));
        }

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

        construct {
            this.charmap_window = new Gtk.Window (Gtk.WindowType.POPUP);
            this.charmap_window.set_size_request (INITIAL_WIDTH,
                                                  INITIAL_HEIGHT);
            var charmap = new CharmapPanel ();
            charmap.select.connect (on_charmap_select);
            this.charmap_window.add (charmap);
            // Pass around "hide" signal to charmap panel, to tell
            // that the toplevel window is hidden - this is necessary
            // to clear zoom window (see CharmapPanel#on_hide()).
            this.charmap_window.hide.connect (() => charmap.hide ());

            // Manually disable all other instances of this engine as
            // IBus 1.4 no longer destroy engines.
            foreach (var engine in this.instances) {
                engine.disable ();
            }
            this.instances.append (this);
        }

        private void show_charmap_window () {
            this.charmap_window.show_all ();
            if (this.x >= 0 && this.y >= 0)
                this.charmap_window.move (this.x, this.y);
        }

        private void hide_charmap_window () {
            if (this.charmap_window != null) {
                this.charmap_window.hide ();
            }
        }

        public override void set_cursor_location (int x, int y, int w, int h) {
            if (this.charmap_window == null)
                return;

            // TODO: More precise placement calculation
            Gtk.Allocation allocation;
            this.charmap_window.get_allocation (out allocation);

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

            if ((this.x != x || this.y != y))
                this.charmap_window.move (x, y);
            this.x = x;
            this.y = y;
        }
    }
}
