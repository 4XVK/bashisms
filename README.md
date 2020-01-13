# bashisms

A curated assortement of useful scripts and bash functions for the average developer

## Versioning

Some scripts may be untested and will be versioned as alpha until then (Example: `0.x.y`)

Versions of each script are given above the function header in the corresponding script files

Versions are also available within the [scripts](#Scripts) section

## Requirements

All non standard dependencies are listed for each script within the [scripts](#Scripts) section

The exact installation methods for these dependencies are not provided, but project links are

## Systems

These scripts have been tested to work on the following generic systems

* MacOS
* Linux

## Installation

To easily include all functions in your profile, do the following

```
git clone git@github.com:devquack/bashisms.git ~/.bashisms
```

And add the follwing into your `.bashrc` or something similar

```
...

# source all bashisms functions
for f in $(find ~/.bashisms/scripts -type f); do source $f; done

...
```

This is one example meant for simplicity, these functions can be included however you prefer

## Usage

If installed using the methods above, these functions can be referenced as functions on the command line

```
> msync --help
Extract maven artifacts and sync them to a remote destination

Usage: _help [-h|--help] [-d|--delete] <-p|--pom $arg> ... [-r|--remote $arg] ...

-h|--help       display help text and exit
-f|--delete     delete artifact directory upon completion
-p|--pom        pom file or directory containing a pom.xml
-r|--remote     remote destination leveraging rsync format
```

## Scripts

All of these scripts are formatted into functions so they may be easily added to a `.bashrc` or something similar

* [msync.sh](scripts/msync.sh) (`v0.2.0`) - Extract maven artifacts and sync them to a remote destination
    * Requirements - [maven](https://maven.apache.org/install.html)
* [wsync.sh](scripts/wsync.sh) (`v0.2.0`) - Watch for changes and sync a location to a remote desination
    * Requirements - [inotifytools](https://github.com/rvoicilas/inotify-tools/wiki#getting) (Linux), [fswatch](https://github.com/emcrisostomo/fswatch#getting-fswatch) (MacOS)
* [wexec.sh](scripts/wexec.sh) (`v0.1.0`) - Watch for changes on a location and optionally execute commands
    * Requirements - [inotifytools](https://github.com/rvoicilas/inotify-tools/wiki#getting) (Linux), [fswatch](https://github.com/emcrisostomo/fswatch#getting-fswatch) (MacOS)
* [socks.sh](scripts/socks.sh) (`v0.2.0`) - Start an SSH SOCKS proxy to a remote desination
* [dsocks.sh](scripts/dsocks.sh) (`v0.2.0`) - Start a double SSH SOCKS proxy from one remote host through another

## License

[The MIT License](LICENSE.md)