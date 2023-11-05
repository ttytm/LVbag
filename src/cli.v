import cli
import os
import v.vmod

struct Settings {
	scan_dirs []string
	output    string
	append    bool
	force     bool
	include   []string
	ignore    []string
	regex     bool
	hidden    bool
	lv_bag    string
	mod_name  string
	verbose   bool
	skip_fmt  bool
}

const manifest = vmod.decode($embed_file('../v.mod').to_string()) or { panic(err) }

fn start_cli() {
	mut app := cli.Command{
		name: 'lvb'
		usage: '<path>'
		version: manifest.version
		description: manifest.description
		pre_execute: fn (cmd cli.Command) ! {
			if cmd.args.len == 0 {
				eprintln('Specify the path to create a embedded file bag.\n')
				cmd.execute_help()
				exit(0)
			}
			// TODO: Accept multiple input paths.
			if cmd.args.len > 1 {
				eprintln('Too many paths ${cmd.args}. Currently, only one path can be specified.\n')
				cmd.execute_help()
				exit(1)
			}
		}
		execute: run
		posix_mode: true
		disable_man: true
		flags: [
			cli.Flag{
				flag: .string
				name: 'output'
				abbrev: 'o'
				description: 'The output file name. If none is set, the result is printed to stdout.'
			},
			cli.Flag{
				flag: .bool
				name: 'append'
				abbrev: 'a'
				description: 'Append the result to the output file.'
			},
			cli.Flag{
				flag: .bool
				name: 'force'
				abbrev: 'f'
				description: 'Overwrite the output file if it already exists.'
			},
			// TODO:
			cli.Flag{
				flag: .string_array
				name: 'include'
				abbrev: 'i'
				description: 'Include the paths in the target directories if they contain these strings.'
			},
			cli.Flag{
				flag: .string_array
				name: 'ignore'
				abbrev: 'I'
				description: 'Ignore the paths in the target directories if they contain these strings.'
			},
			cli.Flag{
				flag: .bool
				name: 'regex'
				abbrev: 'r'
				description: 'Treat the ignore string as a regex pattern.'
			},
			cli.Flag{
				flag: .bool
				name: 'hidden'
				abbrev: 'h'
				description: 'Include hidden files.'
			},
			cli.Flag{
				flag: .string
				name: 'lv_bag'
				abbrev: 'bag'
				description: 'The name of the handbag variable [default: `lv_bag`].'
				default_value: ['lv_bag']
			},
			cli.Flag{
				flag: .string
				name: 'mod_name'
				abbrev: 'mod'
				description: 'Specify the module name used in the output.'
			},
			cli.Flag{
				flag: .bool
				name: 'verbose'
				abbrev: 'v'
				description: 'Enable extended information prints.'
			},
			cli.Flag{
				flag: .bool
				name: 'skip-format'
				description: 'Skip formatting of the output file.'
			},
		]
	}
	app.parse(os.args)
}

fn get_settings(cmd cli.Command) !Settings {
	return Settings{
		scan_dirs: cmd.args
		output: cmd.flags.get_string('output')!
		append: cmd.flags.get_bool('append')!
		force: cmd.flags.get_bool('force')!
		include: cmd.flags.get_strings('include')!
		ignore: cmd.flags.get_strings('ignore')!
		regex: cmd.flags.get_bool('regex')!
		hidden: cmd.flags.get_bool('hidden')!
		lv_bag: cmd.flags.get_string('lv_bag')!
		mod_name: cmd.flags.get_string('mod_name')!
		verbose: cmd.flags.get_bool('verbose')!
		skip_fmt: cmd.flags.get_bool('skip-format')!
	}
}
