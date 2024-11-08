https://nightly.link/hmenke/nixexprs/workflows/cache/master/artifact.zip

### All-in-one download and extract

```shell
python3 <<EOF
from urllib.request import urlretrieve
from shutil import unpack_archive
from os import remove
from os.path import expanduser

print("Downloading...")
urlretrieve("https://nightly.link/hmenke/nixexprs/workflows/cache/master/artifact.zip", "artifact.zip")

try:
    print("Extracting artifact...")
    unpack_archive("artifact.zip")
finally:
    remove("artifact.zip")

try:
    print("Extracting local-bin...")
    unpack_archive("local-bin.tar.gz", expanduser("~"))
finally:
    remove("local-bin.tar.gz")
    remove("local-libexec.tar.gz")
EOF
```

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
