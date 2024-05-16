# LVbag

[badge__build]: https://img.shields.io/github/actions/workflow/status/ttytm/LVbag/ci.yml?style=flat-roundedbranch=main&logo=githubactions&logoColor=C0CAF5&labelColor=333
[badge__version]: https://img.shields.io/github/v/release/ttytm/LVbag?style=flat-rounded&logo=task&logoColor=C0CAF5&labelColor=333
[badge__license]: https://img.shields.io/github/license/ttytm/LVbag?style=flat-rounded&logo=opensourcehardware&label=License&logoColor=C0CAF5&labelColor=333

[![][badge__build]](https://github.com/ttytm/LVbag/actions?query=branch%3Amain)
[![][badge__version]](https://github.com/ttytm/LVbag/releases/latest)
[![][badge__license]](https://github.com/ttytm/LVbag/blob/main/LICENSE)

> Generate embedded file lists for directories. LVbag can serve as an occasional helper with static
> directories or become a part of the build process to assist in embedding dynamic files

```
Usage: lvb [flags] [commands] <path>

A large and handy file bag for V. It simplifies carrying files with your programs
by generating embed file lists for directories based on your specifications.

Flags:
  -o    --output       The output file name. If none is set, the result is printed to stdout.
  -a    --append       Append the result to the output file.
  -f    --force        Overwrite the output file if it already exists.
  -I    --ignore       Ignore the paths in the target directories if they contain these strings.
  -r    --regex        Treat the ignore string as a regex pattern.
  -h    --hidden       Include hidden files.
  -bag  --lv_bag       The name of the handbag variable [default: `lv_bag`].
  -mod  --mod_name     Specify the module name used in the output.
  -v    --verbose      Enable extended information prints.
        --skip-format  Skip formatting of the output file.
        --help         Prints help information.
        --version      Prints version information.

Commands:
  help                 Prints help information.
  version              Prints version information.
```

## Installation

- The projects [GitHub releases page](https://github.com/ttytm/LVbag/releases) provides prebuilt binaries for GNU/Linux, Windows and macOS.

## Usage Examples

- Add a path without additional flags to print the output to the terminal.

  ```sh
  lvb examples/gui_project/ui
  ```

  ```v
  const lv_bag = [
  	$embed_file('/home/t/Dev/vlang/lvb/examples/gui_project/ui/src/main.js')
  	$embed_file('/home/t/Dev/vlang/lvb/examples/gui_project/ui/src/style.css')
  	$embed_file('/home/t/Dev/vlang/lvb/examples/gui_project/ui/src/index.html')
  ]
  ```

- Append to an existing file, specify a "bag" name (specifying a single file as path won't create an array).

  ```sh
  # Append to an existing file `foo.v`
  lvb -bag icon -o foo.v -a assets/icon.ico
  ```

  ```v
  // foo.v
  module main

  const foo = "foo"

  const icon = $embed_file('<path>/ui_project/assets/icon.ico')
  ```

- Add a module name to the output, make the output print verbose.

  ```sh
  lvb -mod bar -v examples/ui_project/ui
  ```

  ![lvb](https://github.com/ttytm/webview/assets/34311583/6c3697eb-65a7-4c96-8619-13af37945051)

## App examples

Simple Application examples that utilize this tool can be found in the [<kbd>.examples/</kbd>](https://github.com/ttytm/LVbag/tree/main/examples) directory.

An example application that uses LVbag to embed the files of a dynamic npm build output is [emoji-mart-desktop](https://github.com/ttytm/emoji-mart-desktop)

## Development

To compile the app yourself, clone the repository and build the release version.

```sh
# Clone the repository
git clone https://github.com/ttytm/LVbag.git
cd LVbag

# Install dependencies - LVB uses PCRE
v install --once

# Build and run as usual in development
v run .

# Build the release version
v -cc gcc -prod -o lvb .
```
