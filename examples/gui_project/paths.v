import os { join_path }

struct Paths {
mut:
	ui   string
	icon string
}

const paths = get_paths()

fn get_paths() Paths {
	return $if embed ? {
		// For a longer lifetime of the UI files: Instead of a temp directory,
		// it could be a cache directory with a version key.
		app_tmp := join_path(os.temp_dir(), 'lvb_example')
		Paths{
			ui: join_path(app_tmp, 'ui')
			icon: join_path(app_tmp, 'assets', 'icon.ico')
		}
	} $else {
		app_root := @VMODROOT
		Paths{
			ui: join_path(app_root, 'ui', 'src')
			icon: join_path(app_root, 'assets', 'icon.ico')
		}
	}
}
