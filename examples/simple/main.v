import os

const (
	app_tmp     = os.join_path(os.temp_dir(), 'lvb-example--simple')
	ui_dev_path = os.join_path(@VMODROOT, 'ui')
	ui_path     = $if prod { os.join_path(app_tmp, 'ui') } $else { ui_dev_path }
)

// Re-crate files from LVbag generated list if they don't exist yet.
[if prod]
fn write_embedded() {
	if os.exists(ui_path) {
		return
	}
	// Lets pretend it contains some more files.
	for file in lv_bag {
		out_path := file.path.replace(ui_dev_path, ui_path)
		os.mkdir_all(os.dir(out_path)) or {}
		os.write_file(out_path, file.to_string()) or {
			eprintln(err)
			return
		}
	}
}

fn main() {
	write_embedded()
	os.open_uri(os.join_path(ui_path, 'index.html'))!
}
