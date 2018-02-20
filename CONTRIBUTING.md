# Contributing to AluthgeSinhaBase

This document provides information on contributing to the AluthgeSinhaBase source code. For information on installing and using AluthgeSinhaBase, please see [README.md](README.md).

<table>
    <thead>
        <tr>
            <th>Table of Contents</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="left"><a href="#1-required-tools">1. Required tools</a></td>
        </tr>
        <tr>
            <td align="left"><a href="#2-">2. Setting up the AluthgeSinhaBase repo for development</a></td>
        </tr>
    </tbody>
</table>

## 1. Required tools

You need to configure the following:
- GitHub account
- git
- git-flow
- GPG

### 1.1 GitHub account

**Step 1:** If you do not already have a GitHub account, go to [https://github.com/join](https://github.com/join) and create an account.

**Step 2:** Go to [https://help.github.com/articles/configuring-two-factor-authentication-via-a-totp-mobile-app/](https://help.github.com/articles/configuring-two-factor-authentication-via-a-totp-mobile-app/) and follow the instructions to enable two-factor authentication for your Github account.

**Step 3:**

**Step 4:**

**Step 5:**

### 1.2 git

**Step 1:**

Open a terminal window and run the following command:
```bash
git --version```
You should see a message that looks something like this:
```
git version 2.16.1
```
If you see a message like this, proceed to Step 2. If you receive an error message, download and install Git:

- Windows: [https://git-scm.com/download/win](https://git-scm.com/download/win)
- macOS: [https://git-scm.com/download/mac](https://git-scm.com/download/mac)
- GNU/Linux: [https://git-scm.com/download/linux](https://git-scm.com/download/linux)

**Step 3:**

**Step 4:**

**Step 5:**

### 1.3 git-flow

**Step 1:**

**Step 2:**

- Windows: []()
- macOS: []()
- GNU/Linux: []()

- Windows: []()
- macOS: []()
- GNU/Linux: []()

**Step 3:**

**Step 4:**

**Step 5:**

### 1.4 GPG

**Step 1:**

**Step 2:**

- Windows: [https://gpg4win.org/download.html](https://gpg4win.org/download.html)
- macOS: [https://gpgtools.org/](https://gpgtools.org/)
- GNU/Linux: [https://gnupg.org/download/#sec-1-2](https://gnupg.org/download/#sec-1-2)

**Step 3:**

**Step 4:**

**Step 5:**



## 2. Setting up the AluthgeSinhaBase repo for development

**Step 1:**

Follow the installation instructions in [README.md](README.md) to install AluthgeSinhaBase.

**Step 2:**

```bash
cd ~/.julia/v0.6/AluthgeSinhaBase
```

**Step 3:**

```bash
git checkout master && git checkout develop && git flow init -d
```

**Step 4:**

```bash
git config commit.gpgsign true
```
