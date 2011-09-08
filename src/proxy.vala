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

namespace IBus {
    [DBus(name = "org.freedesktop.IBus.Charmap")]
    public interface Charmap : Object {
        public enum MovementStep {
            LOGICAL_POSITIONS = 0,
            VISUAL_POSITIONS,
            WORDS,
            DISPLAY_LINES,
            DISPLAY_LINE_ENDS,
            PARAGRAPHS,
            PARAGRAPH_ENDS,
            PAGES,
            BUFFER_ENDS,
            HORIZONTAL_PAGES
        }

        public abstract void show () throws IOError;
        public abstract void hide () throws IOError;
        public abstract void set_cursor_location (int x, int y, int w, int h) throws IOError;
        public abstract void move_cursor (MovementStep step, int count) throws IOError;
        public abstract void select_character (unichar uc) throws IOError;
        public abstract void activate_selected () throws IOError;
        public abstract void popup_chapters () throws IOError;
        public signal void character_activated (unichar uc);

        public abstract void start_search (string name, uint max_matches) throws IOError;
        public abstract void cancel_search () throws IOError;
    }
}
