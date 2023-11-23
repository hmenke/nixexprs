https://nightly.link/hmenke/nixexprs/workflows/cache/master/local-bin.zip

### Download

```shell
curl -LO https://nightly.link/hmenke/nixexprs/workflows/cache/master/local-bin.zip
wget https://nightly.link/hmenke/nixexprs/workflows/cache/master/local-bin.zip
```

### Unpack top level

```shell
unzip local-bin.zip
python3 -c 'import shutil; shutil.unpack_archive("local-bin.zip")'
```

### Unpack contents

```shell
tar -kxvf local-bin.tar.gz -C ~
```

### Using Git

*Disclaimer:* Not everything works as expected.

```shell
export GIT_EXEC_PATH="$HOME/.local/libexec/git-core"
export PATH="$GIT_EXEC_PATH:$PATH"
```
