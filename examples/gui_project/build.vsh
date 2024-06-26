#!/usr/bin/env -S v

import os

const app_root = @VMODROOT

fn build_ui() ! {
	print('Build UI...')
	// This could be the path to the build result of an node project including generated files with hashed names.
	build_dir := join_path(app_root, 'ui', 'build')
	// Remove `ui/build/` if it exits - ignore errors if it doesn't
	rmdir_all(build_dir) or {}
	// Create `ui/build/` - fail is next to impossible as `dist/` does not exist at this point
	mkdir(build_dir)!
	// Mock a dynamic node build: Copy UI files to `ui/build/`.
	walk(join_path('ui', 'src'), fn [build_dir] (file string) {
		cp(file, join_path(build_dir, file_name(file))) or { panic(err) }
	})
	println('\rBuild UI ✔️')
}

fn gen_embeds() ! {
	print('Embed Files...')
	chdir(app_root)!
	if !is_file('../../lvb') {
		execute_opt('v -o ../../lvb ../../')!
	}
	// Use LVbag to generate the embed file lists.
	execute_opt('../../lvb -bag ui_files -o lvb.v -f ui/build')!
	execute_opt('../../lvb -bag icon -o lvb.v -a assets/icon.ico')!
	println('\rEmbed Files ✔️')
}

fn build_bin() ! {
	cc := $if macos { 'clang' } $else { 'gcc' }
	mut p := new_process(find_abs_path_of_executable('v') or {
		return error('Failed finding V.\nMake sure it is executable.')
	})
	p.set_args(['-cc', cc, '-prod', '-d', 'embed', app_root])
	cmd_str := 'v ${p.args.join(' ')}'
	print('Build Binary. Running: `${cmd_str}` ...')
	os.flush()
	p.wait()
	println('\rBuild Binary ✔️ ${' '.repeat('Running: `${cmd_str}` ...'.len)}')
}

build_ui()!
gen_embeds()!
build_bin()!

println('Finished.')
