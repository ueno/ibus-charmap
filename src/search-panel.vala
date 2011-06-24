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
    class CharacterRenderer : Gtk.CellRendererText {
        private unichar _codepoint;
        public unichar codepoint {
            get {
                return _codepoint;
            }
            set {
                _codepoint = value;
                text = _codepoint.to_string ();
            }
        }
    }

	class SearchPanel : Gtk.Box {
		private Gtk.Entry entry;
        private Gtk.TreeView matches;

		private static Sqlite.Database database;
        private uint idle_search_id = 0;

        public signal void activate_character (unichar uc);

		public void append_c (char c) {
			var text = entry.get_text ();
			StringBuilder builder = new StringBuilder (text);
			builder.append_c (c);
			entry.set_text (builder.str);
            update_matches ();
		}

		public void delete_c () {
			var text = entry.get_text ();
			StringBuilder builder = new StringBuilder (text);
			builder.truncate (builder.len - 1);
			entry.set_text (builder.str);
            update_matches ();
		}

		public void erase () {
			entry.set_text ("");
            update_matches ();
		}

        public string get_text () {
            return entry.get_text ();
        }

        public void activate_selected () {
            Gtk.TreePath path;
            matches.get_cursor (out path, null);
            matches.row_activated (path, matches.get_column (0));
        }

        public void move_cursor (Gtk.MovementStep step, int count) {
            if (step == Gtk.MovementStep.DISPLAY_LINES) {
                Gtk.TreePath path;
                matches.grab_focus ();
                matches.get_cursor (out path, null);
                while (count < 0) {
                    path.prev ();
                    count++;
                }
                while (count > 0) {
                    path.next ();
                    count--;
                }
                var store = matches.get_model ();
                Gtk.TreeIter iter;
                if (store.get_iter (out iter, path))
                    matches.set_cursor (path, null, false);
            }
        }

        private void on_row_activated (Gtk.TreePath path,
                                       Gtk.TreeViewColumn column)
        {
            var store = matches.get_model ();
            Gtk.TreeIter iter;
            store.get_iter (out iter, path);
            unichar uc;
            store.get (iter, 0, out uc);
            activate_character (uc);
        }

        private bool idle_search () {
			var text = entry.get_text ();
            var store = (Gtk.ListStore)matches.get_model ();
            
            Sqlite.Statement stmt;
            string sql = """
SELECT codepoint, name FROM unicode_names WHERE name LIKE ? LIMIT 100;
""";
            int rc;

            rc = database.prepare (sql, sql.length, out stmt);
            if (rc != Sqlite.OK) {
                stderr.printf ("can't prepare statement: %s\n",
                               database.errmsg ());
                return false;
            }

            rc = stmt.bind_text (1, "%" + text.replace ("%", "%%") + "%");
            if (rc != Sqlite.OK) {
                stderr.printf ("can't bind values: %s\n",
                               database.errmsg ());
                return false;
            }

            Gtk.TreeIter iter;
            bool valid = store.get_iter_first (out iter);

            int n_matches = 0;
            while (true) {
                rc = stmt.step ();
                if (rc == Sqlite.ROW) {
                    if (!valid)
                        store.insert (out iter, n_matches++);
                    store.set (iter,
                               0, (uint)stmt.column_int64 (0),
                               1, stmt.column_text (1));
                    valid = store.iter_next (ref iter);
                } else if (rc == Sqlite.DONE) {
                    break;
                } else {
                    stderr.printf ("can't step: %s\n",
                                   database.errmsg ());
                    break;
                }
            }

            while (valid)
                valid = store.remove (iter);

            if (store.get_iter_first (out iter))
                matches.set_cursor (store.get_path (iter), null, false);
                
            return false;
        }
        
        private void update_matches () {
			var text = entry.get_text ();
            var store = (Gtk.ListStore)matches.get_model ();

            if (idle_search_id > 0)
                Source.remove (idle_search_id);

            if (text.length == 0)
                store.clear ();
            else
                idle_search_id = Idle.add (idle_search);
        }

		static construct {
			var filename = Path.build_filename (Config.PACKAGE_DATADIR,
												Config.UNICODENAMESFILE);
            int rc;

            rc = Sqlite.Database.open (filename, out database);
            if (rc != Sqlite.OK) {
                stderr.printf ("can't open database\n");
                assert_not_reached ();
            }
		}

		public SearchPanel () {
            var paned = new Gtk.VBox (false, 0);

            // Search entry
			entry = new Gtk.Entry ();
			paned.pack_start (entry, false, false, 0);

            // Match results tree view
            var scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.set_policy (Gtk.PolicyType.NEVER,
                                        Gtk.PolicyType.AUTOMATIC);
            scrolled_window.set_shadow_type(Gtk.ShadowType.ETCHED_IN);

            var model = new Gtk.ListStore (2,
                                           typeof (unichar),
                                           typeof (string));
            matches = new Gtk.TreeView.with_model (model);
            Gtk.CellRenderer renderer = new CharacterRenderer ();
            matches.insert_column_with_attributes (-1,
                                                    "codepoint",
                                                    renderer, "codepoint", 0);
            renderer = new Gtk.CellRendererText ();
            matches.insert_column_with_attributes (-1,
                                                    "name",
                                                    renderer, "text", 1);
            matches.set_headers_visible (false);
            matches.row_activated.connect (on_row_activated);

            var column = matches.get_column (1);
            column.set_sizing (Gtk.TreeViewColumnSizing.FIXED);

            scrolled_window.add (matches);
            paned.pack_end (scrolled_window, true, true, 0);

            paned.show_all ();

            this.pack_start (paned, true, true, 0);
		}
	}
}
