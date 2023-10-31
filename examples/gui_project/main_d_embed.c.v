import os

// Re-crate files from LVbag generated list if they don't exist yet.
fn write_embedded() ! {
	if !os.exists(paths.ui) {
		// Lets play pretend it contains some more files.
		for file in ui_files {
			out_path := file.path.replace(paths.ui_dev, paths.ui)
			os.mkdir_all(os.dir(out_path)) or {}
			os.write_file(out_path, file.to_string())!
		}
	}
	if !os.exists(paths.icon) {
		path := icon.path.replace(paths.icon_dev, paths.icon)
		os.mkdir_all(os.dir(path)) or {}
		os.write_file(path, icon.to_string())!
	}
}
