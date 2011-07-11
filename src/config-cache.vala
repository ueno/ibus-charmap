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
        private const string CONFIG_SECTION = "engine/Gucharmap";
        private IBus.Config config;
        private bool dirty = false;
        private bool loaded = false;
        public signal void changed ();

        private bool _use_system_font = true;
        public bool use_system_font {
            get {
                if (!loaded)
                    load ();
                return _use_system_font;
            }
            set {
                if (value != _use_system_font) {
                    dirty = true;
                    _use_system_font = value;
                }
            }
        }

        private string _font = "Sans 12";
        public string font {
            get {
                if (!loaded)
                    load ();
                return _font;
            }
            set {
                if (value != _font) {
                    dirty = true;
                    _font = value;
                }
            }
        }

        private int _number_of_matches = 100;
        public int number_of_matches {
            get {
                if (!loaded)
                    load ();
                return _number_of_matches;
            }
            set {
                if (value != _number_of_matches) {
                    dirty = true;
                    _number_of_matches = value;
                }
            }
        }

        public ConfigCache (IBus.Config config) {
            this.config = config;

            // Simply invalidate all the values.
            this.config.value_changed.connect (
                (config, section, name, value) => {
                    loaded = false;
                    changed ();
                });
        }

        private void load () {
            if (!loaded) {
                Variant value;

                value = config.get_value (CONFIG_SECTION,
                                          "use_system_font");
                if (value != null)
                    _use_system_font = value.get_boolean ();

                value = config.get_value (CONFIG_SECTION,
                                          "font");
                if (value != null)
                    _font = value.get_string ();

                value = config.get_value (CONFIG_SECTION,
                                          "number_of_matches");
                if (value != null)
                    _number_of_matches = value.get_int32 ();
            }
        }

        public void save () {
            if (dirty) {
                config.set_value (CONFIG_SECTION,
                                  "use_system_font",
                                  new Variant.boolean (_use_system_font));
                config.set_value (CONFIG_SECTION,
                                  "font",
                                  new Variant.string (_font));
                config.set_value (CONFIG_SECTION,
                                  "number_of_matches",
                                  new Variant.int32 (
                                      (int32)_number_of_matches));
                dirty = false;
            }
        }
    }
}
