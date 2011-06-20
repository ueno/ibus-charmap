/* gucharmap-2.90.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Gucharmap", lower_case_cprefix = "gucharmap_", gir_namespace = "Gucharmap", gir_version = "2.90")]
namespace Gucharmap {
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class BlockChaptersModel : Gucharmap.ChaptersModel, Gtk.TreeModel, Gtk.TreeDragSource, Gtk.TreeDragDest, Gtk.TreeSortable, Gtk.Buildable {
		[CCode (type = "GucharmapChaptersModel*", has_construct_function = false)]
		public BlockChaptersModel ();
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class BlockCodepointList : Gucharmap.CodepointList {
		[CCode (type = "GucharmapCodepointList*", has_construct_function = false)]
		public BlockCodepointList (unichar start, unichar end);
		[NoAccessorMethod]
		public uint first_codepoint { get; construct; }
		[NoAccessorMethod]
		public uint last_codepoint { get; construct; }
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class ChaptersModel : Gtk.ListStore, Gtk.TreeModel, Gtk.TreeDragSource, Gtk.TreeDragDest, Gtk.TreeSortable, Gtk.Buildable {
		[CCode (has_construct_function = false)]
		protected ChaptersModel ();
		public virtual bool character_to_iter (unichar wc, Gtk.TreeIter iter);
		public virtual unowned Gucharmap.CodepointList get_book_codepoint_list ();
		public virtual unowned Gucharmap.CodepointList get_codepoint_list (Gtk.TreeIter iter);
		public unowned string get_title ();
		public bool id_to_iter (string id, Gtk.TreeIter iter);
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class ChaptersView : Gtk.TreeView, Atk.Implementor, Gtk.Buildable, Gtk.Scrollable {
		[CCode (type = "GtkWidget*", has_construct_function = false)]
		public ChaptersView ();
		public unowned Gucharmap.CodepointList get_book_codepoint_list ();
		public unowned Gucharmap.CodepointList get_codepoint_list ();
		public unowned Gucharmap.ChaptersModel get_model ();
		public unowned string get_selected ();
		public void next ();
		public void previous ();
		public bool select_character (unichar wc);
		public bool select_locale ();
		public void set_model (Gucharmap.ChaptersModel model);
		public bool set_selected (string name);
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class Charmap : Gtk.Paned, Atk.Implementor, Gtk.Buildable, Gtk.Orientable {
		[CCode (type = "GtkWidget*", has_construct_function = false)]
		public Charmap ();
		public unowned string get_active_chapter ();
		public unichar get_active_character ();
		public unowned Gucharmap.CodepointList get_active_codepoint_list ();
		public int get_active_page ();
		public unowned Gucharmap.CodepointList get_book_codepoint_list ();
		public unowned Gucharmap.ChaptersModel get_chapters_model ();
		public unowned Gucharmap.ChaptersView get_chapters_view ();
		public bool get_chapters_visible ();
		public unowned Gucharmap.Chartable get_chartable ();
		public unowned Pango.FontDescription get_font_desc ();
		public bool get_font_fallback ();
		public Gtk.Orientation get_orientation ();
		public bool get_page_visible (int page);
		public bool get_snap_pow2 ();
		public void next_chapter ();
		public void previous_chapter ();
		public void set_active_chapter (string chapter);
		public void set_active_character (unichar uc);
		public void set_active_page (int page);
		public void set_chapters_model (Gucharmap.ChaptersModel model);
		public void set_chapters_visible (bool visible);
		public void set_font_desc (Pango.FontDescription font_desc);
		public void set_font_fallback (bool enable_font_fallback);
		public void set_orientation (Gtk.Orientation orientation);
		public void set_page_visible (int page, bool visible);
		public void set_snap_pow2 (bool snap);
		public string active_chapter { get; set; }
		public uint active_character { get; set; }
		public Gucharmap.CodepointList active_codepoint_list { get; }
		public uint active_page { get; set; }
		public Gucharmap.ChaptersModel chapters_model { set construct; }
		public Pango.FontDescription font_desc { get; set; }
		public bool font_fallback { get; set; }
		[NoAccessorMethod]
		public bool snap_power_2 { get; set; }
		public virtual signal void link_clicked (uint old_character, uint new_character);
		public virtual signal void status_message (string message);
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class Chartable : Gtk.DrawingArea, Atk.Implementor, Gtk.Buildable, Gtk.Scrollable {
		[CCode (type = "GtkWidget*", has_construct_function = false)]
		public Chartable ();
		public unichar get_active_character ();
		public unowned Gucharmap.CodepointList get_codepoint_list ();
		public unowned Pango.FontDescription get_font_desc ();
		public bool get_font_fallback ();
		public bool get_snap_pow2 ();
		public bool get_zoom_enabled ();
		[NoWrapper]
		public virtual void set_active_char (uint ch);
		public void set_active_character (unichar wc);
		public void set_codepoint_list (Gucharmap.CodepointList codepoint_list);
		public void set_font_desc (Pango.FontDescription font_desc);
		public void set_font_fallback (bool enable_font_fallback);
		[NoWrapper]
		public virtual void set_scroll_adjustments (Gtk.Adjustment hadjustment, Gtk.Adjustment vadjustment);
		public void set_snap_pow2 (bool snap);
		public void set_zoom_enabled (bool enabled);
		public uint active_character { get; set; }
		public Gucharmap.CodepointList codepoint_list { get; set; }
		public Pango.FontDescription font_desc { get; set; }
		public bool font_fallback { get; set; }
		[NoAccessorMethod]
		public bool snap_power_2 { get; set; }
		public bool zoom_enabled { get; set; }
		[NoAccessorMethod]
		public bool zoom_showing { get; }
		public virtual signal void activate ();
		public virtual signal void copy_clipboard ();
		public virtual signal bool move_cursor (Gtk.MovementStep step, int count);
		public virtual signal void paste_clipboard ();
		public virtual signal void status_message (string message);
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class CodepointList : GLib.Object {
		[CCode (has_construct_function = false)]
		protected CodepointList ();
		public virtual unichar get_char (int index);
		public virtual int get_index (unichar wc);
		public virtual int get_last_index ();
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class ScriptChaptersModel : Gucharmap.ChaptersModel, Gtk.TreeModel, Gtk.TreeDragSource, Gtk.TreeDragDest, Gtk.TreeSortable, Gtk.Buildable {
		[CCode (type = "GucharmapChaptersModel*", has_construct_function = false)]
		public ScriptChaptersModel ();
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public class ScriptCodepointList : Gucharmap.CodepointList {
		[CCode (type = "GucharmapCodepointList*", has_construct_function = false)]
		public ScriptCodepointList ();
		public bool append_script (string script);
		public bool set_script (string script);
		public bool set_scripts (string scripts);
	}
	[CCode (cprefix = "GUCHARMAP_CHARMAP_PAGE_", cheader_filename = "gucharmap/gucharmap.h")]
	public enum CharmapPageType {
		CHARTABLE,
		DETAILS
	}
	[CCode (cprefix = "GUCHARMAP_UNICODE_VERSION_", cheader_filename = "gucharmap/gucharmap.h")]
	public enum UnicodeVersion {
		UNASSIGNED,
		@1_1,
		@2_0,
		@2_1,
		@3_0,
		@3_1,
		@3_2,
		@4_0,
		@4_1,
		@5_0,
		@5_1,
		@5_2,
		@6_0,
		LATEST
	}
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public const int VERSION_MAJOR;
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public const int VERSION_MICRO;
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public const int VERSION_MINOR;
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_nameslist_colons (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_nameslist_equals (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unichar get_nameslist_exes (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_nameslist_pounds (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_nameslist_stars (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_category_name (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_data_name (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static int get_unicode_data_name_count ();
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_kCantonese (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_kDefinition (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_kJapaneseKun (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_kJapaneseOn (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_kKorean (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_kMandarin (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_kTang (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string get_unicode_name (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static Gucharmap.UnicodeVersion get_unicode_version (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static int get_unihan_count ();
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static bool unichar_isdefined (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static bool unichar_isgraph (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static int unichar_to_printable_utf8 (unichar uc, string outbuf);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static UnicodeType unichar_type (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static bool unichar_validate (unichar uc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unichar unicode_get_locale_character ();
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string unicode_get_script_for_char (unichar wc);
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string unicode_list_scripts ();
	[CCode (cheader_filename = "gucharmap/gucharmap.h")]
	public static unowned string unicode_version_to_string (Gucharmap.UnicodeVersion version);
}
