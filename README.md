# ArchLinux: Brightness xrandr

View and change the brightness of a monitor using the `xrandr` command.

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

| **Abbr** | **Long**   | **Information**                                                                                                                                                                                                         |
|----------|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -c       | --current  | Shows the current information: selected monitor and brightness.<br> This option is only compatible with the option `--monitor`.<br> - Required: no<br> - Type:     none<br> - Values:   none<br> - Default:  none       |
| -d       | --decrease | Decrease the brightness.<br> - Required: yes - do not select `--increase`<br> - Type:     unsigned integer<br> - Values:   0 - 100, or more<br> - Default:  none                                                        |
| -h       | --help     | Display information for this command and exit.<br> -Required: no<br> - Type:     none<br> - Values:   none<br> - Default:  none                                                                                         |
| -i       | --increase | Increase the brightness.<br> - Required: yes - do not select `--decrease`<br> - Type:     unsigned integer<br> - Values:   0 - 100, or more<br> - Default:  none                                                        |
| -l       | --limit    | Set the limit of the brightness.<br> - Required: no<br> - Type:     unsigned integer<br> - Values:   0 - 100, or more<br> - Default:  100                                                                               |
| -m       | --monitor  | Sets the name of the monitor, which will change the brightness.<br> It can get the name of the monitor with the `xrandr` command.<br> - Required: no<br> - Type:     string<br> - Values:   HDMI-0<br> - Default:  DP-0 |

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

### Create a [new release][new release url].

- You can choose between a branch or a specific commitment.
    - If your commit is the latest at this time, you can select the 'main' branch.
    - Otherwise, if your commit is old, it's better to choose a specific commit.
- Create a new tag that is larger than the previous one. Use the format vX.X.X, where X equals a number.
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

[new release url]: https://github.com/airvzxf/archlinux-brightness-xrandr/releases/new

[CI deploy to AUR]: https://github.com/airvzxf/archlinux-brightness-xrandr/actions/workflows/deploy-to-aur.yml

[AUR repository]: https://aur.archlinux.org/cgit/aur.git/?h=brightness-xrandr

[AUR webpage package]: https://aur.archlinux.org/packages/brightness-xrandr

[contributing to projects]: https://docs.github.com/en/get-started/quickstart/contributing-to-projects

[fork a repository]: https://docs.github.com/en/get-started/quickstart/contributing-to-projects#creating-a-branch-to-work-on

[brightness xrandr GitHub project]: https://github.com/airvzxf/archlinux-brightness-xrandr

[fork brightness xrandr project]: https://github.com/airvzxf/archlinux-brightness-xrandr/fork