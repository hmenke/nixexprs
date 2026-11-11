[![cache](https://github.com/hmenke/nixexprs/actions/workflows/cache.yml/badge.svg)](https://github.com/hmenke/nixexprs/actions/workflows/cache.yml)
[![schedule](https://github.com/hmenke/nixexprs/actions/workflows/schedule.yml/badge.svg)](https://github.com/hmenke/nixexprs/actions/workflows/schedule.yml)
[![update](https://github.com/hmenke/nixexprs/actions/workflows/update.yml/badge.svg)](https://github.com/hmenke/nixexprs/actions/workflows/update.yml)

### Bootstrap and update

[`bootstrap.sh`](bootstrap.sh) downloads the latest artifact, prints the changes
in package versions and installs `~/.local/bin` and `~/.local/share`.  It
requires `tar`, `gzip` and `diff` and uses whichever of `curl`, `wget` or
`python3` is available for downloading.

```shell
curl -fsSL https://hmenke.github.io/nixexprs/bootstrap.sh | bash
wget -qO- https://hmenke.github.io/nixexprs/bootstrap.sh | bash
```
