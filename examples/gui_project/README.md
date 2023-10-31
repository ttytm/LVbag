# LVbag - GUI Project Example

> **Note**
> The realtive directory when running the commands below is assumed to be `LVbag/examples/gui_project`.

If you have not yet used webview, run:

```sh
# Install dependencies
v install --once
# Linux / macOS
~/.vmodules/webview/build.vsh
# Windows Powershell
v $HOME/.vmodules/webview/build.vsh
```

Build the embedded applicaiton

```sh
./build.vsh
```

This will generate the embedded files the app is using and compile the binary `gui_project`.
You can try running it after moving it to a different directory or renaming the ui directory.

To showcase embedding of files that have a more dynamic nature, the script generates a dynamic variant of the ui files and stores them in `ui/build`. After this step it uses lvb to generate the embedded file list for the generated `ui/build` directory.
