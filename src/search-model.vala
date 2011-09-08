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
    class Candidate {
        private unichar _uc;
        public unichar uc {
            get {
                return _uc;
            }
        }

        private string _name;
        public string name {
            get {
                return _name;
            }
        }

        public Candidate (unichar uc, string name) {
            this._uc = uc;
            this._name = name;
        }
    }

    class SearchModel : Object {
        private static Sqlite.Database database;
        private uint idle_search_id = 0;

        public signal void candidates_updated (string key,
                                               Candidate[] candidates);

        private bool idle_search (string key, uint n_matches) {
            Sqlite.Statement stmt;
            string sql = """
SELECT codepoint, name FROM unicode_names WHERE name LIKE ? LIMIT ?;
""";
            int rc;

            rc = database.prepare (sql, sql.length, out stmt);
            if (rc != Sqlite.OK) {
                stderr.printf ("can't prepare statement: %s\n",
                               database.errmsg ());
                return false;
            }

            rc = stmt.bind_text (1, "%" + key.replace ("%", "%%") + "%");
            if (rc != Sqlite.OK) {
                stderr.printf ("can't bind values: %s\n",
                               database.errmsg ());
                return false;
            }

            rc = stmt.bind_int64 (2, n_matches);
            if (rc != Sqlite.OK) {
                stderr.printf ("can't bind values: %s\n",
                               database.errmsg ());
                return false;
            }

            var candidates = new Gee.ArrayList<Candidate> ();
            while (true) {
                rc = stmt.step ();
                if (rc == Sqlite.ROW) {
                    candidates.add (
                        new Candidate ((unichar)stmt.column_int64 (0),
                                       stmt.column_text (1)));
                } else if (rc == Sqlite.DONE) {
                    break;
                } else {
                    stderr.printf ("can't step: %s\n",
                                   database.errmsg ());
                    break;
                }
            }

            candidates_updated (key, candidates.to_array ());

            return false;
        }

        public void start_search (string key, uint n_matches) {
            if (idle_search_id > 0)
                Source.remove (idle_search_id);
            idle_search_id = Idle.add (() => {
                    return idle_search (key, n_matches);
                });
        }
        
        public void cancel_search () {
            if (idle_search_id > 0)
                Source.remove (idle_search_id);

            candidates_updated ("", new Candidate[0]);
        }

        public SearchModel () throws IOError {
            var filename = Path.build_filename (Config.PACKAGE_DATADIR,
                                                Config.UNICODENAMESFILE);
            int rc;

            rc = Sqlite.Database.open_v2 (filename,
                                          out database,
                                          Sqlite.OPEN_READONLY);
            if (rc != Sqlite.OK) {
                throw new IOError.FAILED ("can't open database");
            }
        }
    }
}
