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
    class CharmapPanel : Gtk.Box {
        private Gtk.ComboBox _chapters;
        public Gtk.ComboBox chapters {
            get { return _chapters; }
        }

        private Gucharmap.Chartable _chartable;
        public Gucharmap.Chartable chartable {
            get { return _chartable; }
        }

        private void on_chapter_changed (Gtk.ComboBox combo) {
            Gtk.TreeIter iter;
            if (combo.get_active_iter (out iter)) {
                var model = (Gucharmap.ChaptersModel)_chapters.get_model ();
                var codepoint_list = model.get_codepoint_list (iter);
                _chartable.set_codepoint_list (codepoint_list);
            }
        }

        private void on_hide (Gtk.Widget widget) {
            // Make sure to clear zoom window when the toplevel window
            // is hidden.
            if (_chartable.get_zoom_enabled ()) {
                _chartable.set_zoom_enabled (false);
                _chartable.set_zoom_enabled (true);
            }
        }

        public void select_character (unichar uc) {
            var model = (Gucharmap.ChaptersModel)_chapters.get_model ();
            Gtk.TreeIter iter;
            if (model.character_to_iter (uc, out iter)) {
                _chapters.set_active_iter (iter);
            }
        }

        public CharmapPanel () {
            var paned = new Gtk.VBox (false, 0);

            // Chapters combo box
            //var model = new Gucharmap.ScriptChaptersModel ();
            var model = new Gucharmap.BlockChaptersModel ();
            model.set_sort_column_id (1, Gtk.SortType.ASCENDING);
            _chapters = new Gtk.ComboBox.with_model (model);
            _chapters.changed.connect (on_chapter_changed);
            var renderer = new Gtk.CellRendererText ();
            _chapters.pack_start (renderer, true);
            _chapters.set_attributes (renderer, "text", 1);
            _chapters.set_vexpand (false);

            paned.pack_start (_chapters, false, false, 0);

            // Chartable
            var scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.set_policy (Gtk.PolicyType.NEVER,
                                        Gtk.PolicyType.AUTOMATIC);
            scrolled_window.set_shadow_type(Gtk.ShadowType.ETCHED_IN);

            _chartable = new Gucharmap.Chartable ();

            // Use normal size GTK font
            var style_context = _chartable.get_style_context ();
            var font_desc = style_context.get_font (Gtk.StateFlags.NORMAL);
            _chartable.set_font_desc (font_desc);
            // Enable zooming for the case that the font is too small
            _chartable.set_zoom_enabled (true);
            this.hide.connect (on_hide);

            scrolled_window.add (_chartable);
            paned.pack_end (scrolled_window, true, true, 0);

            var uc = Gucharmap.unicode_get_locale_character ();
            select_character (uc);

            paned.show_all ();

            this.pack_start (paned, true, true, 0);
        }
    }
}
