# bashisms

A curated assortement of useful scripts and bash functions for the average developer

## Requrements

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

## Scripts

All of these scripts are formatted into functions so they may be easily added to a `.bashrc` or something similar

* [msync.sh](scripts/msync.sh) - Extract maven artifacts and sync them to a remote destination
    * Requirements - [maven](https://maven.apache.org/install.html)
* [wsync.sh](scripts/wsync.sh) - Watch for changes and sync a local folder to a remote desination
    * Requirements - [inotifytools](https://github.com/rvoicilas/inotify-tools/wiki#getting)(Linux), [fswatch](https://github.com/emcrisostomo/fswatch#getting-fswatch)(MacOS)
* [socks.sh](scripts/socks.sh) - Start an SSH SOCKS proxy to a remote desination
* [dsocks.sh](scripts/dsocks.sh) - Start a double SSH SOCKS proxy from one remote host through another

## License

[The MIT License](LICENSE.md)