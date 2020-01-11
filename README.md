# bashisms

A curated assortement of useful scripts and bash functions for the average developer

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

## License

[The MIT License](LICENSE.md)