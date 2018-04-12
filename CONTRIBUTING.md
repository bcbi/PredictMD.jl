# Contributing to PredictMD

This document provides information on contributing to the PredictMD source code. For information on installing and using PredictMD, please see [README.md](README.md).

<table>
    <thead>
        <tr>
            <th>Table of Contents</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="left"><a href="#1-prerequisites">1. Prerequisites</a></td>
        </tr>
        <tr>
            <td align="left"><a href="#2-setting-up-the-predictmd-repo">2. Setting up the PredictMD repo</a></td>
        </tr>
                <tr>
            <td align="left"><a href="#3-working-with-examples">3. Working with examples</a></td>
        </tr>
    </tbody>
</table>

## 1. Prerequisites

You need to have a GitHub account (with two-factor authentication enabled). You also need to have the following tools installed and configured:
- git (with SSH public key authentication)
- git-flow
- GPG

### 1.1 GitHub account

**Step 1:** If you already have a GitHub account, go to [https://github.com/login](https://github.com/login) and log in. If you do not already have a GitHub account, go to [https://github.com/join](https://github.com/join) and create an account.

**Step 2:** Go to [https://help.github.com/articles/configuring-two-factor-authentication-via-a-totp-mobile-app/](https://help.github.com/articles/configuring-two-factor-authentication-via-a-totp-mobile-app/) and follow the instructions to enable two-factor authentication for your GitHub account.

### 1.2 git

**Step 1:** Open a terminal window and run the following command:
```bash
git --version
```

You should see a message that looks something like this:
```
git version 2.16.1
```

If you do, proceed to Step 2. If you instead receive an error message, download and install Git:

- Windows: [https://git-scm.com/download/win](https://git-scm.com/download/win)
- macOS: [https://git-scm.com/download/mac](https://git-scm.com/download/mac)
- GNU/Linux: [https://git-scm.com/download/linux](https://git-scm.com/download/linux)

**Step 2:**
```bash
git config --global user.name "Myfirstname Mylastname"
```

**Step 3:**
```bash
git config user.email "myemailaddress@example.com"
```

**Step 4:**

```bash
git config --global github.user mygithubusername
```

**Step 5:** Follow the steps on each of the following pages in order to generate an SSH key and associate it with your GitHub account:
1. [https://help.github.com/articles/checking-for-existing-ssh-keys/](https://help.github.com/articles/checking-for-existing-ssh-keys/)
2. [https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
3. [https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
4. [https://help.github.com/articles/testing-your-ssh-connection/](https://help.github.com/articles/testing-your-ssh-connection/)
5. [https://help.github.com/articles/working-with-ssh-key-passphrases/](https://help.github.com/articles/working-with-ssh-key-passphrases/)

### 1.3 git-flow

**Step 1:** Open a terminal window and run the following command:
```bash
git flow
```

You should see a message that looks something like this:
```
usage: git flow <subcommand>

Available subcommands are:
   init      Initialize a new git repo with support for the branching model.
   feature   Manage your feature branches.
   release   Manage your release branches.
   hotfix    Manage your hotfix branches.
   support   Manage your support branches.
   version   Shows version information.

Try 'git flow <subcommand> help' for details.
```
If you do, then you are good to go. If you instead receive the message ```git: 'flow' is not a git command```, download and install git-flow:

- Windows: [https://github.com/nvie/gitflow/wiki/Windows](https://github.com/nvie/gitflow/wiki/Windows)
- macOS: [https://github.com/nvie/gitflow/wiki/Mac-OS-X](https://github.com/nvie/gitflow/wiki/Mac-OS-X)
- GNU/Linux: [https://github.com/nvie/gitflow/wiki/Linux](https://github.com/nvie/gitflow/wiki/Linux)


### 1.4 GPG

**Step 1:** Open a terminal window and run the following command:
```bash
gpg --version
```

You should see a message that looks something like this:
```
gpg (GnuPG/MacGPG2) 2.2.3
libgcrypt 1.8.1
Copyright (C) 2017 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Home: /Users/dilum/.gnupg
Supported algorithms:
Pubkey: RSA, ELG, DSA, ECDH, ECDSA, EDDSA
Cipher: IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH,
        CAMELLIA128, CAMELLIA192, CAMELLIA256
Hash: SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
Compression: Uncompressed, ZIP, ZLIB, BZIP2
```
If you do, then go to Step 2. If you instead see an error, download and install GPG:
- Windows: [https://gpg4win.org/download.html](https://gpg4win.org/download.html)
- macOS: [https://gpgtools.org/](https://gpgtools.org/)
- GNU/Linux: [https://gnupg.org/download/#sec-1-2](https://gnupg.org/download/#sec-1-2)

**Step 2:** Follow the steps on each of the following pages in order to generate a GPG key and associate it with your GitHub account:
1. [https://help.github.com/articles/checking-for-existing-gpg-keys/](https://help.github.com/articles/checking-for-existing-gpg-keys/)
2. [https://help.github.com/articles/generating-a-new-gpg-key/](https://help.github.com/articles/generating-a-new-gpg-key/)
3. [https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/](https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/)
4. [https://help.github.com/articles/telling-git-about-your-gpg-key/](https://help.github.com/articles/telling-git-about-your-gpg-key/)
5. [https://help.github.com/articles/associating-an-email-with-your-gpg-key/](https://help.github.com/articles/associating-an-email-with-your-gpg-key/)

## 2. Setting up the PredictMD repo

**Step 1:** Make sure that you have followed all of the instructions in [Section 1 (Prerequisites)](#1-prerequisites).

**Step 2:** Follow the installation instructions in [README.md](README.md) to install PredictMD.

**Step 3:** Open a terminal window and `cd` to the directory containing the PredictMD source code:

```bash
cd ~/.julia/v0.6/PredictMD
```

**Step 4:** Run the following line:

```bash
git config commit.gpgsign true && git checkout master && git checkout develop && git flow init -fd && git checkout develop 
```
## 3. Working with examples

Some of the examples are provided as Jupyter notebooks as a convinient way to visualize and interact with the code. However, we also like to mantain corresponding plain Julia scripts that are in-sync with the notebooks. A convinient way to do so, is to add a post-save hook to your Jupyter configuration file.

1. Open you jupyter configuration file ~/.jupyter/jupyter_notebook_config.py. If the file does not exist you can generate it by running `jupyter notebook --generate-config`

2. Add the following code to the top of the file

```python
#-----------------------------------------------------------------------------
# Auto save script version of notebook
# Reference: https://svds.com/jupyter-notebook-best-practices-for-data-science/
#-----------------------------------------------------------------------------

import os
from subprocess import check_call

def post_save(model, os_path, contents_manager):
    """post-save hook for converting notebooks to .py scripts"""
    if model['type'] != 'notebook':
        return # only do this for notebooks
    d, fname = os.path.split(os_path)
    check_call(['jupyter', 'nbconvert', '--to', 'script', fname], cwd=d)

c.FileContentsManager.post_save_hook = post_save
```

**Note:** This behavior is global. If you want to have this saving only when in a particular folder, you can create multiple configuration files as a work-around. First create a new profile name via a bash command line:
```bash
export JUPYTER_CONFIG_DIR=~/.jupyter_profile2
jupyter notebook --generate-config
```
This will create a new directory and file at `~/.jupyter_profile2/jupyter_notebook_config.py` Then run jupyter notebook and work as usual. To switch back to your default profile you will have to set (either by hand, shell function, or your .bashrc) back to:  

```bash
export JUPYTER_CONFIG_DIR=~/.jupyter
```
