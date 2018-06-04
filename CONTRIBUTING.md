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
            <td align="left"><a href="#appendix-a-information-for-package-maintainers">Appendix A: Information for package maintainers</a></td>
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
git config commit.gpgsign true && git remote set-url origin https://github.com/bcbi/PredictMD.jl.git && git remote set-url --push origin git@github.com:bcbi/PredictMD.jl.git && git checkout master && git checkout develop && git flow init -fd && git checkout develop && git fetch --all --prune
```

## Appendix A: Information for package maintainers

### A.1. How to tag a new release using git-flow

**IMPORTANT: Before you tag a new release, make sure that your GPG set-up is working. Release tags MUST be signed with your GPG key.**

**Step 1:** Open a terminal window and `cd` to the directory containing the PredictMD source code:

```bash
cd ~/.julia/v0.6/PredictMD
```

**Step 2:** Fetch the latest versions of all branches:

```bash
git fetch --all --prune
```

**Step 3:** Checkout the develop branch:

```bash
git checkout develop
```

**Step 4:** Pull the latest version of develop.

```bash
git pull
```

**Step 5:** Determine the version number that you are going to release. We use the Semantic Versioning scheme: [https://semver.org/](https://semver.org/). In Semantic Versioning, version numbers take the form `vMAJOR.MINOR.PATCH`. We increment the `MAJOR` version when we make incompatible (non-backwards-compatible) API changes. We increment the `MINOR` version when we add functionality in a backwards-compatible manner. We increment the `PATCH` version when we make backwards-compatible bug fixes.

For this example, let's pretend that the current version is `v30.770.25`, and we are adding functionality in a backwards-compatible manner. So we increment the `MINOR` version, which means the new version that we are tagging is `v30.771.0`.

**Step 6:** Start a new release branch.

```bash
git flow release start v30.771.0
```

You MUST begin the name of the release with the letter "v".

*If you subsequently forget what you named your release branch, you can list all of the release branches by running the following command:* `git flow release list`

**Step 7:** Open the source file `src/base/version.jl` and increment the version number. For example, if the file looks like this:

```julia
const VERSION = try
    convert(VersionNumber, "THE OLD VERSION NUMBER WILL BE HERE")
catch e
    warn("While creating PredictMD.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
```

Then you would edit it to look like this:

```julia
const VERSION = try
    convert(VersionNumber, "v30.771.0")
catch e
    warn("While creating PredictMD.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
```

**Step 8:** Commit your changes:

```bash
git add src/base/version.jl

git commit
```
An commit message editor will open. Type an appropriate commit message (e.g. "Bump version number"), save the file, and quit the editor.

**Step 9:** Push the release branch so that Travis CI will build it and run the tests.

```bash
git push origin release/v30.771.0
```

**Step 10:** Wait for all of the tests to pass. You can check on the status of the tests by going to [https://github.com/bcbi/PredictMD.jl/branches/yours](https://github.com/bcbi/PredictMD.jl/branches/yours) and scrolling down to find your release branch.

* A yellow dot indicates that the tests are still running. Click on the yellow dot to see which tests are still running.
* A red "X" indicates that one or more of the tests failed. Click on the red "X" to see which tests failed.
* A green check mark indicates that all of the tests passed.

**You must wait for all of the tests to pass (green check mark) before you can finish tagging the release.**

*Sometimes, one of the build jobs will fail because a download timed out. This is especially common with the Mac builds on Travis. You can usually resolve this error by restarting the failed build.*

**Step 11:**  Once all of the Travis tests have passed, you can finish tagging your release using the git-flow tools:


```bash
git flow release finish -s v30.771.0
```

*You MUST include the `-s` flag, because this is how you tell git-flow to sign the release tag with your GPG key. The "s" is lowercase.*

Several commit message editors will open, one after the other. Some of them will have the correct commit message already filled in, e.g. "Merge branch ... into branch ...". In those cases, simply save the file, and quit the editor. One of the editors, however, will ask you to enter the message for the tag `v30.771.0`. In this editor, enter a reasonable release message (e.g. "PredictMD version 30.771.25"), save the file, and close the editor.

Once you have finished all of the commits and tags, you must verify that you have correctly signed the release tag:

**Step 12:** Verify that you have correctly signed the release tag. First, list all of the tags, and make sure that your new tag appears in the list:
```bash
git tag -ln
```

Now, verify the GPG signature of your release tag:
```bash
git tag -v v30.771.0
```

If you see a message similar to this:
```
gpg: Signature made Thu May 24 13:56:48 2018 EDT
gpg:                using RSA key 36666C5CF81D90773604A1208CF0AA45DD38E4A0
gpg: Good signature from "Dilum Aluthge <dilum@aluthge.com>" [ultimate]
```

then you have successfully signed the release, and you may proceed to Step 13. However, if you don't see that message, then you have not signed the tag successfully, and you may NOT proceed. At this point, you should [open a new issue](https://github.com/bcbi/PredictMD.jl/issues/new) and mention [@DilumAluthge](https://github.com/DilumAluthge) in the issue body.

**Step 13:** Temporarily modify the branch protections for the `master` and `develop` branches:

First, the `master` branch: go to [https://github.com/bcbi/PredictMD.jl/settings/branches/master](https://github.com/bcbi/PredictMD.jl/settings/branches/master), scroll down, UNCHECK the box next to "Include administrators", scroll to the bottom of the page, and click the green "Save changes" button. You may be asked to enter your GitHub password.

Now do the same thing for the `develop` branch: Go to [https://github.com/bcbi/PredictMD.jl/settings/branches/develop](https://github.com/bcbi/PredictMD.jl/settings/branches/develop), scroll down, UNCHECK the box next to "Include administrators", scroll to the bottom of the page, and click the green "Save changes" button.

**Step 14:** Push the new release to GitHub:

```bash
git push origin master # push the updated "master" branch
git push origin develop # push the updated "develop" branch
git push origin --tags # push the new "v30.771.0" tag
```

**Step 15:** Bump the version number again to indicate that the develop branch is in a developmental state. First, determine what the next version number will be, and then append "-DEV" to the end of the version string to indicate that it is currently in a developmental state

In our example, we have just released `v30.771.0`. If we are planning on our next release being be backwards compatible, then the next version number will be `v30.772.0`, and thus you should set the current version number to `v30.772.0-DEV`. In contrast, if we are planning that the next release will be breaking (non-backwards-compatible), then the next version number will be `v31.0.0`, and thus you should set the current version number to `v31.0.0-DEV`. You need to determine what that next version number will be, and then.

First, checkout the `develop` branch:
```bash
git checkout develop
```

Now, open the `src/base/version.jl` file and edit the version number accordingly. For our example, if we are planning on our next release being be backwards compatible, then we would edit `src/base/version.jl` to look like this:
```julia
const VERSION = try
    convert(VersionNumber, "v30.772.0-DEV")
catch e
    warn("While creating PredictMD.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
```

On the other hand, if we are planning that the next release will be breaking (non-backwards-compatible), then we would edit `src/base/version.jl` to look like this:
```julia
const VERSION = try
    convert(VersionNumber, "v31.0.0-DEV")
catch e
    warn("While creating PredictMD.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
```

**Step 16:** Commit your changes:

```bash
git add src/base/version.jl

git commit
```
An commit message editor will open. Type an appropriate commit message (e.g. "Bump version number"), save the file, and quit the editor.

**Step 17:** Push the updated develop branch:
```bash
git push origin develop
```

**Step 18:** Re-enable the branch protection settings:

`master` branch: go to [https://github.com/bcbi/PredictMD.jl/settings/branches/master](https://github.com/bcbi/PredictMD.jl/settings/branches/master), scroll down, CHECK the box next to "Include administrators", scroll to the bottom of the page, and click the green "Save changes" button.

`develop` branch: go to [https://github.com/bcbi/PredictMD.jl/settings/branches/develop](https://github.com/bcbi/PredictMD.jl/settings/branches/develop), scroll down, CHECK the box next to "Include administrators", scroll to the bottom of the page, and click the green "Save changes" button.

**Step 19:** Create a release on GitHub using the tag you just created, signed, and pushed. First, go to [https://github.com/bcbi/PredictMD.jl/releases/new](https://github.com/bcbi/PredictMD.jl/releases/new). In the text box that reads "Tag version", type the name of the tag you just released. For our example, you would type "v30.771.0". Next, in the text box that reads "Release title", type an appropriate title, such as "PredictMD version 30.771.0". Finally, click the green "Publish release" button.

Congratulations, you are finished making the release!
