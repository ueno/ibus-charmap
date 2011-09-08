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

namespace IBusCharmap {
	public class GtkService : Service {
        // const values
        private const int INITIAL_WIDTH = 320;
        private const int INITIAL_HEIGHT = 240;

        private int saved_x;
        private int saved_y;

        private Gtk.Window window;
		private WindowPlacement placement;

        private Gtk.Container panel;
        private CharmapPanel charmap_panel;
        private SearchPanel search_panel;

        public GtkService (DBusConnection conn) {
            window = new Gtk.Window (Gtk.WindowType.POPUP);
            window.set_size_request (INITIAL_WIDTH, INITIAL_HEIGHT);
            charmap_panel = new CharmapPanel ();
            charmap_panel.character_activated.connect ((uc) => {
                    character_activated (uc);
                });

            search_panel = new SearchPanel ();
            search_panel.character_activated.connect ((uc) => {
                    cancel_search ();
                    charmap_panel.select_character (uc);
                    character_activated (uc);
                });

            panel = charmap_panel;
            window.add (panel);

            // Pass around "hide" signal to charmap panel, to tell
            // that the toplevel window is hidden - this is necessary
            // to clear zoom window (see CharmapPanel#on_hide()).
            window.hide.connect (() => charmap_panel.hide ());

			placement = new WindowPlacement ();

			register_charmap (conn);
        }

		public override void show () {
            window.show_all ();
			placement.restore_location (window);
		}

		public override void hide () {
            if (window != null) {
                window.hide ();
            }
		}

        public override void set_cursor_location (int x, int y, int w, int h) {
			placement.set_location_from_cursor (window, x, y, w, h);
        }

        public override void move_cursor (IBus.Charmap.MovementStep step,
                                          int count)
		{
			((Selectable)panel).move_cursor (step, count);
		}

        public override void select_character (unichar uc) {
            if (panel == charmap_panel)
                charmap_panel.select_character (uc);
        }

        public override void activate_selected () {
            ((Selectable)panel).activate_selected ();
		}

		public override void popup_chapters () {
            if (panel == charmap_panel)
                charmap_panel.popup_chapters ();
		}

		public override void start_search (string name, uint max_matches) {
            search_panel.start_search (name, max_matches);
            window.remove (window.get_child ());
            panel = search_panel;
            window.add (panel);
            if (window.get_visible ())
                window.show_all ();
		}

		public override void cancel_search () {
            search_panel.cancel_search ();
            window.remove (window.get_child ());
            panel = charmap_panel;
            window.add (panel);
		}
	}
}