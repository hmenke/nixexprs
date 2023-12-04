https://nightly.link/hmenke/nixexprs/workflows/cache/master/artifact.zip

### Download

```shell
curl -LO https://nightly.link/hmenke/nixexprs/workflows/cache/master/artifact.zip
wget https://nightly.link/hmenke/nixexprs/workflows/cache/master/artifact.zip
python3 -c 'from urllib.request import *; urlretrieve("https://nightly.link/hmenke/nixexprs/workflows/cache/master/artifact.zip", "artifact.zip")'
```

### Unpack top level

```shell
unzip artifact.zip
python3 -c 'import shutil; shutil.unpack_archive("artifact.zip")'
```

### Unpack contents

```shell
tar -kxvf local-bin.tar.gz -C ~
tar -kxvf local-libexec.tar.gz -C ~
```

### Using Git

*Disclaimer:* Not everything works as expected.

```shell
export GIT_EXEC_PATH="$HOME/.local/libexec/git-core"
export PATH="$GIT_EXEC_PATH:$PATH"
```
