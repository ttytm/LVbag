import os
import log
import pcre
import term
import cli

const hidden_re = pcre.new_regex('(\\${os.path_separator}\\.\\w+)', 0) or { panic(err) }

fn main() {
	$if lv_log ? {
		log.set_level(.debug)
	}
	start_cli()
}

fn run(cmd cli.Command) ! {
	log.debug('cmd: ${cmd}')
	s := get_settings(cmd)!
	log.debug('settings: ${s}')

	if s.include.len != 0 && s.ignore.len != 0 {
		eprintln('error: Specify at most one of --include(-i) or --ignore(-I).')
		exit(1)
	}
	if s.mod_name != '' && s.append {
		eprintln('error: --mod-name(-mod) cannot be used with --append(-a).')
		exit(1)
	}

	mut incl_paths := []string{}
	mut excl_matches := []string{} // used for logging purposes.
	mut i_ref := &incl_paths
	mut e_ref := &excl_matches

	// NOTE: Technically looping is atm not be necessary, since only a single input path
	// is accepted. So this is more of a prelude for multiple paths.
	for path in s.scan_dirs {
		if os.is_file(path) {
			incl_paths << os.abs_path(path)
			continue
		}
		os.walk(path, fn [s, mut i_ref, mut e_ref] (fp string) {
			check_path := os.abs_path(fp)
			// Case: Include all.
			if s.hidden && s.ignore.len == 0 {
				i_ref << check_path
				return
			}
			// Case: Exclude hidden.
			if !s.hidden {
				if m := hidden_re.match_str(check_path, 0, 0) {
					e_ref << '(${m.get_all()}): "${check_path}"'
					return
				}
			}
			// Case: No ignore patterns specified.
			if s.ignore.len == 0 {
				i_ref << check_path
				return
			}
			if s.regex {
				// TODO: re-investigate. Passing re as closure unfortunately didn't produce matches.
				for p in s.ignore {
					re := pcre.new_regex('(${p.replace('\\', '\\\\')})', 0) or { panic(err) }
					if m := re.match_str(check_path, 0, 0) {
						e_ref << '(${m.get_all()}): "${check_path}"'
					} else {
						i_ref << check_path
					}
				}
			} else if s.ignore.any(check_path.contains(it)) {
				e_ref << check_path
			} else {
				i_ref << check_path
			}
		})
	}

	log.debug('Exclude paths: ${excl_matches}')
	log.debug('Include paths: ${incl_paths}')

	if incl_paths.len == 0 {
		println('No files found in: `${s.scan_dirs[0]}`.')
		exit(0)
	}

	// Prepare output file content.
	mut res := if s.mod_name == '' { '' } else { 'module ${s.mod_name}\n\n' }
	res += 'const ${s.lv_bag} = '
	if os.is_dir(s.scan_dirs[0]) {
		res += '[\n'
	}
	for path in incl_paths {
		res += "\t\$embed_file('${path}')\n"
	}
	if os.is_dir(s.scan_dirs[0]) {
		res += ']'
	}

	// Case: Write to Stdout.
	if s.output == '' {
		print_res(res, s.verbose)
		return
	}

	log.debug('Result:\n${res}')

	// Case: Write to file.
	if s.append {
		append_res(s.output, res) or { error_and_exit(err) }
	} else {
		write_res(s.output, res, s.force) or { error_and_exit(err) }
	}

	if !s.skip_fmt {
		os.execute_opt('${@VEXE} fmt -w ${s.output}') or { error_and_exit(err) }
	}

	verbose_print(s.verbose, 'Completed.')
}

fn print_res(res string, verbose bool) {
	width, _ := term.get_terminal_size()
	sep := '='.repeat(if width < 80 { width } else { 80 })
	verbose_print(verbose, term.colorize(term.bright_black, 'Result:\n${sep}'))
	println(res)
	verbose_print(verbose, term.colorize(term.bright_black, '${sep}\nCompleted.'))
}

fn append_res(out_path string, res string) ! {
	mut f := os.open_append(out_path)!
	f.write_string(res)!
	f.close()
}

fn write_res(out_path string, res string, force bool) ! {
	if !force && os.is_file(out_path) {
		return error('Output file "${out_path}" already exists. Run with "--force" or "-f" to overwrite.')
	}
	os.write_file(out_path, res)!
}

[noreturn]
fn error_and_exit(err IError) {
	eprintln(err.str())
	exit(1)
}

fn verbose_print(on bool, str string) {
	if on {
		println(str)
	}
}
