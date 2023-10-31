#!/usr/bin/env -S v

const app_root = @VMODROOT

// Use LVbag to generate the embed file lists.
fn gen_embeds() ! {
	println('Embedding files')
	chdir(app_root)!
	if !is_file('../../lvb') {
		execute_opt('v -o ../../lvb ../../')!
	}
	execute_opt('../../lvb -o lvb.v -f ui')!
}

fn build_bin() ! {
	cc := $if macos { 'clang' } $else { 'gcc' }
	cmd := 'v -cc ${cc} -prod ${app_root}/'
	println('Building binary\n  running: `${cmd}`')
	execute_opt($if windows { 'powershell -command ${cmd}' } $else { cmd })!
}

gen_embeds()!
build_bin()!

println('\rFinished.')
