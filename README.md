# ArchLinux: Brightness xrandr

View and change the brightness of a monitor using the `xrandr` command.

## HELP

### USAGE:

`brightness-xrandr [OPTIONS]`

### DESCRIPTION

It changes the brightness using the command `xrandr`.

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
