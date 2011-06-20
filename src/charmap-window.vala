class CharmapWindow : Gtk.Box {
	private Gucharmap.ChaptersView _chapters_view;
	private Gucharmap.Chartable _chartable;

	public Gucharmap.Chartable chartable {
		get { return _chartable; }
	}

	public signal void select (unichar uc);

	private void on_chapter_selection_changed (Gtk.TreeSelection selection) {
		Gtk.TreeModel model;
		Gtk.TreeIter iter;
		if (selection.get_selected (out model, out iter)) {
			var codepoint_list = this._chapters_view.get_codepoint_list ();
			this.chartable.set_codepoint_list (codepoint_list);
		}
	}

	private void on_chartable_activate (Gucharmap.Chartable chartable) {
        var uc = chartable.get_active_character ();
		if (uc > 0)
			select (uc);
	}

	public CharmapWindow () {
		var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

		// chapters
		var scrolled_window = new Gtk.ScrolledWindow (null, null);
		scrolled_window.set_policy (Gtk.PolicyType.NEVER,
									Gtk.PolicyType.AUTOMATIC);
		scrolled_window.set_shadow_type(Gtk.ShadowType.ETCHED_IN);

		this._chapters_view = new Gucharmap.ChaptersView ();
		this._chapters_view.set_headers_visible (false);

		var model = new Gucharmap.ScriptChaptersModel ();
		this._chapters_view.set_model (model);

		var selection = this._chapters_view.get_selection ();
		selection.changed.connect (on_chapter_selection_changed);

		scrolled_window.add (this._chapters_view);
		paned.pack1 (scrolled_window, false, true);

		// chartable
		scrolled_window = new Gtk.ScrolledWindow (null, null);
		scrolled_window.set_policy (Gtk.PolicyType.NEVER,
									Gtk.PolicyType.AUTOMATIC);
		scrolled_window.set_shadow_type(Gtk.ShadowType.ETCHED_IN);

		this._chartable = new Gucharmap.Chartable ();
		this._chartable.set_zoom_enabled (true);
		this._chartable.activate.connect (on_chartable_activate);
		scrolled_window.add (this._chartable);
		paned.pack2 (scrolled_window, true, true);

		this._chapters_view.select_locale ();

		paned.set_position (150);
		paned.show_all ();

		this.pack_start (paned, true, true, 0);
	}
}
