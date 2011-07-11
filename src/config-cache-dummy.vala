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
    class ConfigCache : Object {
        private IBus.Config config;
        public signal void changed ();

        private bool _use_system_font = true;
        public bool use_system_font {
            get {
                return _use_system_font;
            }
            set {
				_use_system_font = value;
            }
        }

        private string _font = "Sans 12";
        public string font {
            get {
                return _font;
            }
            set {
                    _font = value;
            }
        }

        private int _number_of_matches = 100;
        public int number_of_matches {
            get {
                return _number_of_matches;
            }
            set {
				_number_of_matches = value;
            }
        }

        public ConfigCache (IBus.Config config) {
            this.config = config;
        }

		public void load () {
			warning ("loading config with ibus 1.3 is not supported");
		}

		public void save () {
			warning ("saving config with ibus 1.3 is not supported");
		}
    }
}
