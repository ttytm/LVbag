import os

fn init() {
	write_embedded() or {
		eprintln('failed to write embedded files: `${err}`')
		exit(1)
	}
}

fn write_embedded() ! {
	// Re-crate files from LVbag generated list if they don't exist yet.
	if !os.exists(paths.ui) {
		// Lets pretend it contains some more files.
		ui_src_path := os.join_path('ui', 'src')
		for file in ui_files {
			_, rel_file_path := file.path.rsplit_once(ui_src_path) or {
				return error('failed to prepare path for ${file.path}')
			}
			out_path := os.join_path(paths.ui, rel_file_path)
			os.mkdir_all(os.dir(out_path)) or {}
			os.write_file(out_path, file.to_string())!
		}
	}
	if !os.exists(paths.icon) {
		os.mkdir_all(os.dir(paths.icon)) or {}
		os.write_file(paths.icon, icon.to_string())!
	}
}
