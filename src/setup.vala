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
    class Setup : Object {
        private Gtk.Dialog dialog;
        private Gtk.CheckButton use_system_font_checkbutton;
        private Gtk.FontButton fontbutton;
        private Gtk.SpinButton number_of_matches_spinbutton;
        private Gtk.Entry select_chapter_entry;
        private Gtk.Button select_chapter_button;
        private Gtk.Entry commit_character_entry;
        private Gtk.Button commit_character_button;
        private Settings settings;

        public bool use_system_font {
            get {
                return use_system_font_checkbutton.get_active ();
            }
            set {
                use_system_font_checkbutton.set_active (value);
            }
        }

        public string font {
            get {
                return fontbutton.get_font_name ();
            }
            set {
                fontbutton.set_font_name (value);
            }
        }

        public int number_of_matches {
            get {
                return (int)number_of_matches_spinbutton.value;
            }
            set {
                number_of_matches_spinbutton.set_value (value);
            }
        }

        public string select_chapter_shortcut {
            get {
                return select_chapter_entry.get_text ();
            }
            set {
                select_chapter_entry.set_text (value);
            }
        }

        public string commit_character_shortcut {
            get {
                return commit_character_entry.get_text ();
            }
            set {
                commit_character_entry.set_text (value);
            }
        }

        public Setup () {
            var builder = new Gtk.Builder ();
            builder.set_translation_domain ("ibus-gucharmap");
            builder.add_from_file (
                Path.build_filename (Config.SETUPDIR,
                                     "ibus-gucharmap-preferences.ui"));

            // Map widgets defined in ibus-gucharmap-preferences.ui
            // into instance variables.
            var object = builder.get_object ("dialog");
            dialog = (Gtk.Dialog)object;
            object = builder.get_object ("fontbutton");
            fontbutton = (Gtk.FontButton)object;
            object = builder.get_object ("use_system_font_checkbutton");
            use_system_font_checkbutton = (Gtk.CheckButton)object;
            object = builder.get_object ("number_of_matches_spinbutton");
            number_of_matches_spinbutton = (Gtk.SpinButton)object;
            object = builder.get_object ("select_chapter_entry");
            select_chapter_entry = (Gtk.Entry)object;
            object = builder.get_object ("select_chapter_button");
            select_chapter_button = (Gtk.Button)object;
            object = builder.get_object ("commit_character_entry");
            commit_character_entry = (Gtk.Entry)object;
            object = builder.get_object ("commit_character_button");
            commit_character_button = (Gtk.Button)object;

            // set signal handlers
            use_system_font_checkbutton.toggled.connect ((checkbutton) => {
                    fontbutton.set_sensitive (!checkbutton.active);
                });
            select_chapter_button.clicked.connect ((button) => {
                    var dialog = new KeyCaptureDialog ("chapter selection",
                                                       dialog);
                    if (dialog.run () == Gtk.ResponseType.OK)
                        select_chapter_entry.set_text (dialog.key);
                    dialog.destroy ();
                });
            commit_character_button.clicked.connect ((button) => {
                    var dialog = new KeyCaptureDialog ("commit character",
                                                       dialog);
                    if (dialog.run () == Gtk.ResponseType.OK)
                        commit_character_entry.set_text (dialog.key);
                    dialog.destroy ();
                });

            // bind gsettings values to properties
            settings = new Settings ("org.freedesktop.ibus.engines.gucharmap");
            settings.bind ("use-system-font",
                           this, "use-system-font",
                           SettingsBindFlags.DEFAULT);
            settings.bind ("font",
                           this, "font",
                           SettingsBindFlags.DEFAULT);
            settings.bind ("number-of-matches",
                           this, "number-of-matches",
                           SettingsBindFlags.DEFAULT);
            settings.bind ("select-chapter-shortcut",
                           this, "select-chapter-shortcut",
                           SettingsBindFlags.DEFAULT);
            settings.bind ("commit-character-shortcut",
                           this, "commit-character-shortcut",
                           SettingsBindFlags.DEFAULT);
        }

        private void save_settings () {
            use_system_font = use_system_font_checkbutton.active;
            font = fontbutton.font_name;
            number_of_matches = (int)number_of_matches_spinbutton.value;
            select_chapter_shortcut = select_chapter_entry.get_text ();
            commit_character_shortcut = commit_character_entry.get_text ();
        }

        public void run () {
            dialog.run ();
            save_settings ();
        }
    }
}
