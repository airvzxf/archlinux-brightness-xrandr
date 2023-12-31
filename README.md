# ArchLinux: Brightness xrandr

Command-line tool that display and change the brightness of a monitor using the `xrandr` command.

## INFORMATION

### USAGE:

`brightness-xrandr [OPTIONS]`

### DESCRIPTION

Command-line tool that changes the brightness using the `xrandr` command.

- Executing the command: `xrandr --output MONITOR --brightness NEW_BRIGHTNESS`.
- NEW_BRIGHTNESS:
  This value is calculated using the following formula: the current brightness
  value (plus or minus) the value obtained from the BRIGHTNESS option.

### ARGS:

- None.

### OPTIONS:

| **Abbr** | **Long**         | **Information**                                                                                                                                                                                                  |
|----------|------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -c       | --current        | Shows the current information: selected monitor and brightness.<br> This option is only compatible with the option `--monitor`.<br> - Required: no<br> - Type: none<br> - Values: none<br> - Default: none       |
| -d       | --decrease       | Decrease the brightness.<br> - Required: yes - do not select `--increase`<br> - Type: unsigned integer<br> - Values: 0 - 100, or more<br> - Default: none                                                        |
| -h       | --help           | Display information for this command and exit.<br> -Required: no<br> - Type: none<br> - Values: none<br> - Default: none                                                                                         |
| -i       | --increase       | Increase the brightness.<br> - Required: yes - do not select `--decrease`<br> - Type: unsigned integer<br> - Values: 0 - 100, or more<br> - Default: none                                                        |
| -l       | --limit          | Set the limit of the brightness.<br> - Required: no<br> - Type: unsigned integer<br> - Values: 0 - 100, or more<br> - Default: 100                                                                               |
| -m       | --monitor        | Sets the name of the monitor, which will change the brightness.<br> It can get the name of the monitor with the `xrandr` command.<br> - Required: no<br> - Type: string<br> - Values: HDMI-0<br> - Default: DP-0 |
| -v       | --version        | Display the version of this tool along with the project information and exit.<br> - Required: no<br> - Type: none<br> - Values: none<br> - Default: none                                                         |
|          | --version-simple | Display the version of this tool and exit.<br> - Required: no<br> - Type: none<br> - Values: none<br> - Default: none                                                                                            |

### EXAMPLES:

- Using the default monitor, increase the brightness.
    - Commands:
        - `brightness-xrandr --increase 3`

- Using the default monitor, decrease the brightness.
    - Commands:
        - `brightness-xrandr --decrease 7`

- Monitor settings and brightness increase.
    - Commands:
        - `brightness-xrandr --monitor HDMI-0 --increase 3`

- Increases the maximum brightness value to 150. Which is equal to 1.5 when
  using the `xrandr` command.
    - In this example, the current brightness value is 95; this will increase
      the brightness value to 110 or 1.10 in `xrandr`. If the limit was 100,
      this would have set the brightness to 100 (1.0) instead of 110 (1.10).
        - `brightness-xrandr --limit 150 --increase 15`

- Get the current brightness of a specific monitor.
    - Commands:
        - `brightness-xrandr --current`
        - `brightness-xrandr --current --monitor HDMI-0`
        - `brightness-xrandr --current --monitor DP-0`

    - Multiple options can be used multiple times. It will only take the last
      value of each option.
        - In this example it will decrease the brightness by 10.
            - `brightness-xrandr --increase 80 --decrease 20 --increase 70 --decrease 10`

## INSTALLATION AND MANUAL EXECUTION

### Installation

#### Introduction

This package is stored in the AUR (Arch Linux User Repository). AUR is a repository where anyone with an Arch Linux web
account can upload a configuration file, which has instructions for downloading and installing the package. In addition,
it contains information on the people who maintain or contribute to it.

#### AUR package installer

Normally, the `pacman` command is used to install official packages. However, this command does not work for AUR
packages. There are specific tools that help AUR package management, like `yay`.

To install this package, first [install yay][install yay] and then run the following
command: `yay --sync brightness-xrandr`.

### Manual execution

[Directly download][raw file of this package] the [brightness-xrandr][this package file] file and use it on your
computer.

Verify that the file has the appropriate execution permissions for your needs: `ls -l brightness-xrandr`. You can
add execute permissions to the owner user with `chmod u+x brightness-xrandr` or to all
with `chmod +x brightness-xrandr`.

Run this tool with one of the following commands.

- `./brightness-xrandr --help`.
- `bash brightness-xrandr --help`.
- `/usr/bin/env bash brightness-xrandr --help`.
- `/usr/bin/bash brightness-xrandr --help`.

## CONTRIBUTE

You can always follow the official GitHub guides: [contributing to projects][contributing to projects]
and [fork a repository][fork a repository].

In short, you can perform the following steps. Let's assume your GitHub user is `XxXxXx`.

Here is a small script that can be run after the first step, which is to fork the project in your account.

```bash
#!/usr/bin/env bash

# Replace these two values to customize your execution.
MY_GITHUB_USER="XxXxXx"
BRANCH_NAME="add-new-options"

git clone "https://github.com/${MY_GITHUB_USER}/archlinux-brightness-xrandr.git"
cd archlinux-brightness-xrandr
git remote add upstream "https://github.com/airvzxf/archlinux-brightness-xrandr.git"
git remote --verbose
git branch "${BRANCH_NAME}"
git checkout "${BRANCH_NAME}"
```

- Navigate to [archlinux-brightness-xrandr][brightness xrandr GitHub project] and create a branch by clicking the branch
  button. Or just click this [link to create it automatically][fork brightness xrandr project].
- On your computer, clone your forked project: `git clone https://github.com/XxXxXx/archlinux-brightness-xrandr.git`.
- Go inside the repository folder: `cd archlinux-brightness-xrandr`.
- Configure Git to sync your fork with the upstream repository.
    - `git remote add upstream https://github.com/airvzxf/archlinux-brightness-xrandr.git`.
    - `git remote --verbose`.
- Always create a new branch to work on your changes.
    - `git branch BRANCH_NAME`.
    - `git checkout BRANCH_NAME`.
- Make your changes and commit them.
    - `git add .`.
    - `git commit --message "Brief description of the changes"`.
- Push your changes to our repository on the GitHub server. The first time you need to specify the upstream, the next
  time use basic push.
    - First time: `git push --set-upstream origin BRANCH_NAME`.
    - `git push`.
- The last step is to create a pull request to push your changes to our repository. This request must
  be accepted by the project owner or maintainers for the changes to take effect.
    - If you go to your repository with the web browser (`https://github.com/XxXxXx/archlinux-brightness-xrandr`), it
      will display the 'Compare & pull request' button. Or use this URL to do it
      easily: `https://github.com/XxXxXx/archlinux-brightness-xrandr/compare/BRANCH_NAME`
    - Fill in all the required information and review the 'Files changed' tab to verify the changes.
    - Tap the 'Create pull request' button to finish.

## RELEASE TO THE AUR SERVER

Use the version format vX.X.X, where X equals to numbers, for example: v45.7.211.

### Change in the source code.

- Manually change the version in [./src/brightness-xrandr][package file in GitHub]. Find the variable `VERSION="vX.X.X"`
  in the first few lines and change it to the new version.
- Check if the variable `ENV_IS_PRODUCTION` has the `true` value
  in [.github/workflows/deploy-to-aur.yml][deploy workflow in GitHub] file.

### Create a [new release][new release url].

- You can choose between a branch or a specific commitment.
    - If your commit is the latest at this time, you can select the 'main' branch.
    - Otherwise, if your commit is old, it's better to choose a specific commit.
- Create a new tag that is larger than the previous one (vX.X.X).
- Add a release title. Preferred to use 'Release vX.X.X'.
- Add a description. It is recommended to add a brief description and use the 'Generate release notes' button.
- Select the option: 'Set as the latest release'.
- Finally, tap the 'Publish release' button.

### Review in the '[CI ➟ Deploy to AUR][CI deploy to AUR]' actions.

- A new workflow run should be started with the title of the version you added in the previous steps.
- It validates that it has finished successfully (green color). If not, review the bug, fix it, and rebuild this
  version.
- If it finished successfully, in the logs at the end, it provides an AUR URL for this specific commit on its servers.
- You can check the [AUR repository information][AUR repository].
- You can check the [package in the AUR website][AUR webpage package].

## TO-DO LIST

### RELEASE

- [ ] Version of this tool. It is not defined, and we have to find the best approach. But definitely, the expectation is
  to look for the simplest and most automated way.
    - Option #1: When you create the release on GitHub, automatically modify the source code by changing the version in
      the script file. Furthermore, make a new commit with these changes, along with a push, and modify in the release
      the commit that is pointed to this last commit.
    - Option #2: It is precisely the opposite of Option #1. The version is assigned in the script or a file. Then find a
      way to automate the release and have it grab the version of the script or file on GitHub. Or even that the release
      is already automated with line commands and not through the website on GitHub, creating an action in the workflow.

[AUR repository]: https://aur.archlinux.org/cgit/aur.git/?h=brightness-xrandr

[AUR webpage package]: https://aur.archlinux.org/packages/brightness-xrandr

[CI deploy to AUR]: https://github.com/airvzxf/archlinux-brightness-xrandr/actions/workflows/deploy-to-aur.yml

[brightness xrandr GitHub project]: https://github.com/airvzxf/archlinux-brightness-xrandr

[contributing to projects]: https://docs.github.com/en/get-started/quickstart/contributing-to-projects

[deploy workflow in GitHub]: .github/workflows/deploy-to-aur.yml

[fork a repository]: https://docs.github.com/en/get-started/quickstart/contributing-to-projects#creating-a-branch-to-work-on

[fork brightness xrandr project]: https://github.com/airvzxf/archlinux-brightness-xrandr/fork

[install yay]: https://github.com/Jguer/yay#installation

[new release url]: https://github.com/airvzxf/archlinux-brightness-xrandr/releases/new

[raw file of this package]: https://raw.githubusercontent.com/airvzxf/archlinux-brightness-xrandr/main/src/brightness-xrandr

[this package file]: ./src/brightness-xrandr
