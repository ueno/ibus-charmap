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

class GucharmapEngine : IBus.Engine {
    private Gtk.Window window;
    private CharmapWindow charmap;
    private int x = -1;
    private int y = -1;

    // const values
    private const int INITIAL_WIDTH = 320;
    private const int INITIAL_HEIGHT = 240;

    private void on_charmap_select (unichar uc) {
		commit_text (new IBus.Text.from_string (uc.to_string ()));
    }

    public override void enable () {
        update_charmap ();
    }

    public override void focus_in () {
        update_charmap ();
    }

    public override void focus_out () {
        this.window.hide ();
    }

    private void update_charmap () {
        if (this.window == null) {
            this.window = new Gtk.Window (Gtk.WindowType.TOPLEVEL);
            this.window.set_keep_above (true);
            this.window.set_accept_focus (false);
            this.window.set_can_focus (false);
            this.window.set_size_request (INITIAL_WIDTH, INITIAL_HEIGHT);
            this.window.set_decorated (false);
            this.charmap = new CharmapWindow ();
            this.window.add (this.charmap);
            this.charmap.select.connect (on_charmap_select);
        }
        this.window.show_all ();
        if (this.x >= 0 && this.y >= 0)
            this.window.move (this.x, this.y);
    }

    public override void set_cursor_location (int x, int y, int w, int h) {
        y += h;
        if (this.x != x || this.y != y)
            this.window.move (x, y);
        this.x = x;
        this.y = y;
    }

    public static void main (string[] args) {
        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, "");
        Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (Config.GETTEXT_PACKAGE);

        Gtk.init (ref args);
        IBus.init ();
        var bus = new IBus.Bus ();

        if (!bus.is_connected ()) {
            stderr.printf ("Can not connect to ibus-daemon!\n");
            return;
        }

        var factory = new IBus.Factory (bus.get_connection());
        factory.add_engine ("gucharmap", typeof(GucharmapEngine));
        bus.request_name ("org.freedesktop.IBus.Gucharmap", 0);
        var component = new IBus.Component (
            "org.freedesktop.IBus.Gucharmap",
            N_("Gucharmap"), "0.0.1", "GPL",
            "Daiki Ueno <ueno@unixuser.org>",
            "http://code.google.com/p/ibus/",
            "",
            "ibus-gucharmap");
        var engine = new IBus.EngineDesc (
            "gucharmap",
            "Unicode (Gucharmap)",
            "Unicode input method using Gucharmap",
            "",
            "GPL",
            "Daiki Ueno <ueno@unixuser.org>",
            "accessories-character-map",
            "us");
        component.add_engine (engine);
        bus.register_component (component);
        IBus.main ();
    }
}
