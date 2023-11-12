import os
import ttytm.webview as ui

fn open_in_browser(e &ui.Event) {
	url := e.get_arg[string](0) or { return }
	os.open_uri(url) or {}
}

fn increment(e &ui.Event) !int {
	return e.get_arg[int](0)! + 1
}

fn main() {
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
