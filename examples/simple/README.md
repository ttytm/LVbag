# LVbag - Simple Example

Disclaminer: A simple application like this, which only embeds one file, does not require such a tool.

But with ~30 lines of code in `main.v` and ~20 in `build.vsh`, it's serves as bite-sized overview of how lvb can be used for larger applications.

## Usage

Run:

```
./build.vsh
```

This will generate the embedded file list for the `ui` directory and compile the binary `simple`.
Since `ui/index.html` is embedded into the binary, you can try running it after moving it to a different directory or renaming the ui directory.

### Additional Information

The the generated embeded output is ignored for the repository, so running the program as usual
requires that the build script was executed once before.

```sh
❯ ./build.vsh
╭─ LVbag/examples/simple
╰─❯ v run .
```

The [`gui_project`](https://github.com/ttytm/LVbag/tree/main/examples/ui_project) is a more extensive example that handles the compile context independent of the existence of the generated file.
