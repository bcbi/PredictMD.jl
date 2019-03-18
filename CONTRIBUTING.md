<!-- Beginning of file -->

# Contributing to PredictMD

This document provides information on contributing to the
PredictMD source code. For information on installing and using
PredictMD, please see [README.md](README.md).

<table>
    <thead>
        <tr>
            <th>Table of Contents</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="left">
                <a href="#1-prerequisites">1. Prerequisites
                </a>
            </td>
        </tr>
        <tr>
            <td align="left">
                <a href="#2-setting-up-the-predictmd-repo">
                    2. Setting up the PredictMD repo
                </a>
            </td>
        </tr>
        <tr>
            <td align="left">
                <a href="#appendix-a-information-for-package-maintainers">
                    Appendix A: Information for package maintainers
                </a>
            </td>
        </tr>
    </tbody>
</table>

## 1. Prerequisites

You need to have a GitHub account (with two-factor authentication enabled).
You also need to have the following tools installed and configured:
- git (with SSH public key authentication)
- git-flow
- GPG

### 1.1 GitHub account

#### Step 1:
If you already have a GitHub account, go to
[https://github.com/login](https://github.com/login) and log in.
If you do not already have a GitHub account, go to
[https://github.com/join](https://github.com/join) and create an account.

#### Step 2:
Go to [https://help.github.com/articles/configuring-two-factor-authentication-via-a-totp-mobile-app/](https://help.github.com/articles/configuring-two-factor-authentication-via-a-totp-mobile-app/)
and follow the instructions to enable two-factor
authentication for your GitHub account.

### 1.2 git

#### Step 1:
Open a terminal window and run the following command:
```bash
git --version
```

You should see a message that looks something like this:
```
git version 2.16.1
```

If you do, proceed to Step 2. If you instead receive an error message,
download and install Git:

- macOS: [https://git-scm.com/download/mac](https://git-scm.com/download/mac)
- GNU/Linux: [https://git-scm.com/download/linux](https://git-scm.com/download/linux)

#### Step 2:
```bash
git config --global user.name "Myfirstname Mylastname"
```

#### Step 3:
```bash
git config user.email "myemailaddress@example.com"
```

#### Step 4:

```bash
git config --global github.user mygithubusername
```

#### Step 5:
Follow the steps on each of the following pages in order to
generate an SSH key and associate it with your GitHub account:
1. [https://help.github.com/articles/checking-for-existing-ssh-keys/](https://help.github.com/articles/checking-for-existing-ssh-keys/)
2. [https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
3. [https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
4. [https://help.github.com/articles/testing-your-ssh-connection/](https://help.github.com/articles/testing-your-ssh-connection/)
5. [https://help.github.com/articles/working-with-ssh-key-passphrases/](https://help.github.com/articles/working-with-ssh-key-passphrases/)

### 1.3 git-flow

#### Step 1:
Open a terminal window and run the following command:
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
If you do, then you are good to go. If you instead receive the
message ```git: 'flow' is not a git command```, download and
install git-flow:

- macOS: [https://github.com/nvie/gitflow/wiki/Mac-OS-X](https://github.com/nvie/gitflow/wiki/Mac-OS-X)
- GNU/Linux: [https://github.com/nvie/gitflow/wiki/Linux](https://github.com/nvie/gitflow/wiki/Linux)


### 1.4 GPG

#### Step 1:
Open a terminal window and run the following command:
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
If you do, then go to Step 2. If you instead see an error,
download and install GPG:
- macOS: [https://gpgtools.org/](https://gpgtools.org/)
- GNU/Linux: [https://gnupg.org/download/#sec-1-2](https://gnupg.org/download/#sec-1-2)

#### Step 2:
Follow the steps on each of the following pages in order to
generate a GPG key and associate it with your GitHub account:
1. [https://help.github.com/articles/checking-for-existing-gpg-keys/](https://help.github.com/articles/checking-for-existing-gpg-keys/)
2. [https://help.github.com/articles/generating-a-new-gpg-key/](https://help.github.com/articles/generating-a-new-gpg-key/)
3. [https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/](https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/)
4. [https://help.github.com/articles/telling-git-about-your-gpg-key/](https://help.github.com/articles/telling-git-about-your-gpg-key/)
5. [https://help.github.com/articles/associating-an-email-with-your-gpg-key/](https://help.github.com/articles/associating-an-email-with-your-gpg-key/)

## 2. Setting up the PredictMD repo

#### Step 1:
Make sure that you have followed all of the instructions
in [Section 1 (Prerequisites)](#1-prerequisites).

#### Step 2:
Open Julia and run the following lines:
```julia
import Pkg;
p = Pkg.PackageSpec(
	name="PredictMD",
	url="https://github.com/bcbi/PredictMD.jl",
	uuid="3e7d7328-36f8-4388-bd01-4613c92c7370",
	);
Pkg.develop(p);
```

#### Step 3:
Open a terminal window and `cd` to the directory
containing the PredictMD source code:

```bash
cd ~/.julia/dev/PredictMD
```

#### Step 4:
Run the following lines:

```bash
git config commit.gpgsign true &&
git remote set-url origin https://github.com/bcbi/PredictMD.jl.git &&
git remote set-url --push origin git@github.com:bcbi/PredictMD.jl.git &&
git checkout master &&
git checkout develop &&
git flow init -fd &&
git checkout develop &&
git fetch --all --prune
```

## Appendix A: Information for package maintainers

### A.1. How to tag a new release using git-flow

**IMPORTANT: Before you tag a new release, make sure that
your GPG set-up is working.
Release tags MUST be signed with your GPG key.**

#### Step 1:
Open a terminal window and `cd` to the directory
containing the PredictMD source code:

```bash
cd ~/.julia/dev/PredictMD
```

#### Step 2:
Fetch the latest versions of all branches:

```bash
git fetch --all --prune
```

#### Step 3:
Checkout the `master` branch:

```bash
git checkout master
```

#### Step 4:
Pull the latest version of `master`.

```bash
git pull
```

#### Step 5:
Checkout the `develop` branch:

```bash
git checkout develop
```

#### Step 6:
Pull the latest version of `develop`.

```bash
git pull
```

#### Step 7:
Determine the version number that you are going to
release. We use the Semantic Versioning
system: [https://semver.org](https://semver.org). In Semantic
Versioning, version numbers take the form `vMAJOR.MINOR.PATCH`.
We increment the `MAJOR` version when we make incompatible
(non-backwards-compatible) API changes. We increment the `MINOR`
version when we add functionality in a backwards-compatible manner.
We increment the `PATCH` version when we make
backwards-compatible bug fixes.

For this example, let's pretend that the current version
is `v3.5.12` and that we are adding functionality in a
backwards-compatible manner. So we increment the `MINOR` version,
which means the new version that we are tagging is `v3.6.0`.

#### Step 8:
Start a new release branch.

```bash
git flow release start v3.6.0
```

**You MUST begin the name of the release with the letter "v".**

*If you subsequently forget what you named your release branch,
you can list all of the release branches by running the following
command:* `git flow release list`

#### Step 9:
Open the file `Project.toml` and change the version number
on line 4. For example, if line 4 of `Project.toml` looks
like this:

```julia
version = "THE OLD VERSION NUMBER WILL BE HERE"
```

Then you would edit line 4 to look like this:

```julia
version = "3.6.0"
```

**Only change line 4 of `Project.toml`
(the line that begins with `version =`.
Do not change any of the other lines.**

#### Step 10:
Commit your changes:

```bash
git add Project.toml

git commit
```
An commit message editor will open. Type an appropriate commit
message (e.g. "Bump version number"), save the file, and quit the
editor.

#### Step 11:

Run the PredictMD test suite on your local machine:

```bash
julia --project -e 'import Pkg; Pkg.instantiate(); Pkg.build("PredictMD"); Pkg.test("PredictMD");'
```

If you receive the message "Testing PredictMD tests passed", then the
tests passed.

If you do not receive that message, then one or more of the tests failed.

**You may not proceed to the next step until all of the tests pass on your
local machine.**

#### Step 12:
Push the release branch to GitHub.

```bash
git push origin release/v3.6.0
```

#### Step 13:
Wait for all of the continuous integration (CI) tests to pass. You can
check on the status of the CI tests by going to
[https://github.com/bcbi/PredictMD.jl/branches/yours](https://github.com/bcbi/PredictMD.jl/branches/yours)
and scrolling down to find your release branch.

* A yellow dot indicates that the CI tests are still running. Click on the
yellow dot to see which tests are still running.
* A red "X" indicates that one or more of the CI tests failed. Click on the
red "X" to see which tests failed.
* A green check mark indicates that all of the CI tests passed.

**You must wait for all of the CI tests to pass (green check mark) before
you can continue.**

*Sometimes, one of the CI tests will fail because a download timed out.
This is especially common with Travis CI on Mac. You can usually
resolve this error by restarting the failed build.*

#### Step 14:
Once all of the tests have passed, you can finish
tagging your release using the git-flow tools:


```bash
git flow release finish -s v3.6.0
```

*You MUST include the `-s` flag, because this is how you tell git-flow
to sign the release tag with your GPG key. The "s" is lowercase.*

Several commit message editors will open, one after the other. Some of
them will have the correct commit message already filled in, e.g.
"Merge branch ... into branch ...". In those cases, simply save the
file, and quit the editor. One of the editors, however, will ask you
to enter the message for the tag `v3.6.0`. In this editor, enter a
reasonable release message (e.g. "PredictMD version 3.6.0"), save
the file, and close the editor.

Once you have finished all of the commits and tags, you must verify
that you have correctly signed the release tag:

#### Step 15:
Verify that you have correctly signed the release tag:
```bash
git tag -v v3.6.0
```

If you see a message similar to this:
```
gpg: Signature made Thu May 24 13:56:48 2018 EDT
gpg:                using RSA key 36666C5CF81D90773604A1208CF0AA45DD38E4A0
gpg: Good signature from "Dilum Aluthge <dilum@aluthge.com>" [ultimate]
```

then you have successfully signed the release, and you may proceed
to the next step. However, if you see a different message, then you have
not signed the tag successfully, and you may NOT proceed. At this
point, you should
[open a new issue](https://github.com/bcbi/PredictMD.jl/issues/new)
and mention [@DilumAluthge](https://github.com/DilumAluthge) in the
issue body.

#### Step 16:
Temporarily modify the branch protections for
the `master` and `develop` branches:

First, the `master` branch: go to
[https://github.com/bcbi/PredictMD.jl/settings/branches](https://github.com/bcbi/PredictMD.jl/settings/branches), scroll down, click the "Edit" button in the `master` row, scroll down, UNCHECK the box next to "Include administrators", scroll
to the bottom of the page, and click the green "Save changes" button.
You may be asked to enter your GitHub password.

Now do the same thing for the `develop` branch: go to
[https://github.com/bcbi/PredictMD.jl/settings/branches](https://github.com/bcbi/PredictMD.jl/settings/branches), scroll down, click the "Edit" button in the `develop` row, scroll down, UNCHECK the box next to "Include administrators", scroll
to the bottom of the page, and click the green "Save changes" button.
You may be asked to enter your GitHub password.

#### Step 17:
Push the new release to GitHub:

```bash
git push origin master # push the updated "master" branch
git push origin develop # push the updated "develop" branch
git push origin --tags # push the new "v3.6.0" tag
```

#### Step 18:
Create a release on GitHub using the tag you just
created, signed, and pushed. First, go to
[https://github.com/bcbi/PredictMD.jl/releases/new](https://github.com/bcbi/PredictMD.jl/releases/new).
In the text box that reads "Tag version", type the name of the tag you
just released. For our example, you would type "v3.6.0". Next, in the
text box that reads "Release title", type an appropriate title, such
as "PredictMD version 3.6.0". Finally, click the green
"Publish release" button.

#### Step 19:
Update the version number in the `develop` branch:

First, use Semantic Versioning ([https://semver.org](https://semver.org))
determine what the next version number will be. In our example, we have
just released `v3.6.0`. If we are planning on our next release being be
backwards compatible, then the next version number will be `v3.7.0`. In
contrast, if we are planning that the next release will be breaking
(non-backwards-compatible), then the next version number will
be `v4.0.0`.

Second, append "-DEV" to the end of the version number. So if the
next version number will be `v3.7.0`, then you should set the
current version number to `v3.7.0-DEV`. In contrast, if the next
version number will be `v4.0.0`, the you should set the current
version number to `v4.0.0-DEV`.

Third, checkout and pull the `develop` branch:
```bash
git checkout develop
git pull
```

Fourth, open the `Project.toml` file and edit line 4
accordingly. For example, to set the version number
to `v3.7.0-DEV`, edit line 4 to be the following:
```julia
version = "3.7.0-DEV"
```

On the other hand, to set the version number to `v4.0.0-DEV`,
edit line 4 of `Project.toml` to be the following:
```julia
version = "4.0.0-DEV"
```

**As before, only change line 4 of `Project.toml`
(the line that begins with `version =`.
Do not change any of the other lines.**

#### Step 20:
Commit your changes:

```bash
git add Project.toml

git commit
```
An commit message editor will open. Type an appropriate commit
message (e.g. "Bump version number"), save the file, and quit
the editor.

#### Step 21:
Push the updated develop branch:
```bash
git push origin develop
```

#### Step 22:
Re-enable the branch protection settings:

`master` branch: go to
[https://github.com/bcbi/PredictMD.jl/settings/branches](https://github.com/bcbi/PredictMD.jl/settings/branches), scroll down, click the "Edit" button in the `master` row, scroll down, CHECK the box next to "Include administrators", scroll
to the bottom of the page, and click the green "Save changes" button.
You may be asked to enter your GitHub password.

`develop` branch: go to
[https://github.com/bcbi/PredictMD.jl/settings/branches](https://github.com/bcbi/PredictMD.jl/settings/branches), scroll down, click the "Edit" button in the `develop` row, scroll down, CHECK the box next to "Include administrators", scroll
to the bottom of the page, and click the green "Save changes" button.
You may be asked to enter your GitHub password.

#### Step 23:
Delete the release branch, which is no longer needed. To do
this, go to
[https://github.com/bcbi/PredictMD.jl/branches/yours](https://github.com/bcbi/PredictMD.jl/branches/yours),
scroll down to find the release branch, and then click the
trash can icon to delete the branch.

#### Step 24:

Tag the new release with [PredictMDRegistry](https://github.com/bcbi/PredictMDRegistry). Instructions are available here: [https://github.com/bcbi/PredictMDRegistry/blob/master/CONTRIBUTING.md](https://github.com/bcbi/PredictMDRegistry/blob/master/CONTRIBUTING.md)

#### Step 25:
The final step is to go to the Zenodo entry for the newly created release and put in the correct information. First go to [https://doi.org/10.5281/zenodo.1291209](https://doi.org/10.5281/zenodo.1291209), and then click on the yellow "Edit" button to edit the most recent release. Then, fill out the following fields with the specified values:

##### Upload type:
* Software

##### Basic information -> Title:
* PredictMD - Uniform interface for machine learning in Julia

##### Basic information -> Authors:

| Name | Affiliation | ORCID |
| --- | -------- | ---- |
| Aluthge DP | Brown Center for Biomedical Informatics, Brown University | 0000-0002-9247-0530 |
| Sinha I | Brown Center for Biomedical Informatics, Brown University |  |
| Stey P | Brown Center for Biomedical Informatics, Brown University |  |
| Restrepo MI | Brown Center for Biomedical Informatics, Brown University | 0000-0002-2708-8984 |
| Chen ES | Brown Center for Biomedical Informatics, Brown University | 0000-0002-6181-3369 |
| Sarkar IN | Brown Center for Biomedical Informatics, Brown University | 0000-0003-2054-7356 |

##### Basic information -> Description:
* PredictMD is a free and open-source Julia package that provides a uniform interface for machine learning.

##### Basic information -> Language:
* English

##### Basic information -> Keywords:
* biomedical informatics
* Julia
* machine learning
* statistics

##### Basic information -> Additional notes:
* Development of PredictMD was supported in part by National Institutes of Health grants U54GM115677, R01LM011963, and R25MH116440. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.

##### License -> License:
* MIT License

##### Related/alternate identifiers -> Related identifiers:

(Replace `vMAJOR.MINOR.PATCH` with the appropriate version number. In our example, you would replace `vMAJOR.MINOR.PATCH` with `v3.6.0`.)

| Identifier | Relationship |
| ---- | ---- |
| `https://predictmd.net` | compiled/created this upload |
| `https://predictmd.net/vMAJOR.MINOR.PATCH` | documents this upload |
| `https://github.com/bcbi/PredictMD.jl/releases/tag/vMAJOR.MINOR.PATCH` | is an alternate identifier of this upload |
| `https://github.com/bcbi/PredictMD.jl/tree/vMAJOR.MINOR.PATCH` | is an alternate identifier of this upload |

After you have entered the correct information in all of the above fields, click the white "Save" button, and then click the blue "Publish" button. Congratulations, you are finished!

<!-- End of file -->
