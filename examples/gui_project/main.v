import os { join_path }
import webview as ui

struct Paths {
mut:
	root     string
	ui_dev   string
	ui       string
	icon_dev string
	icon     string
}

const paths = &Paths{}

fn init() {
	mut p := &Paths{}
	unsafe {
		p = paths
	}
	app_root := @VMODROOT
	// For less re-creation, it could also be the cache directory with a version key instead of the temp directory.
	app_tmp := join_path(os.temp_dir(), 'lvb_example')
	p.ui_dev = join_path(app_root, 'ui', 'src')
	p.ui = $if prod { join_path(app_tmp, 'ui') } $else { p.ui_dev }
	p.icon_dev = join_path(app_root, 'assets', 'icon.ico')
	p.icon = $if prod { join_path(app_tmp, 'assets', 'icon.ico') } $else { p.icon_dev }
}

fn open_in_browser(e &ui.Event) {
	url := e.get_arg[string](0) or { return }
	os.open_uri(url) or {}
}

fn increment(e &ui.Event) !int {
	return e.get_arg[int](0)! + 1
}

fn main() {
	$if embed ? {
		write_embedded() or { eprintln('Failed writing embedded files: `${err}`') }
	}
	// Create a Window.
	w := ui.create()
	w.set_title('UI')
	w.set_size(800, 600, .@none)
	w.set_icon(paths.icon)!
	// Bind V functions.
	w.bind[voidptr]('open_in_browser', open_in_browser)
	w.bind_opt('increment', increment)
	// Serve UI.
	w.navigate('file://${paths.ui}/index.html')
	// Run and wait until the window gets closed.
	w.run()
	w.destroy()
}
