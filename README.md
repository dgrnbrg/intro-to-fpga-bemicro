
# To Simulate:

1) start Modelsim

2) Go to "transcript" window

    cd <demo_directory>
    do compile_all.tcl
    vsim bemicro_tb

3) Go back to "transcript" window

    log -r *
    run -all

4) Go back to "transcript" window

    do bemicro_wave.do

## Waveform viewer commands

* f to zoom out fully
* c to center and zoom in at selected time
* + and - to zoom in and out

## To Recompile

Go to "transcript" window

    do compile_all.tcl
    restart -force; run -all

# Ubuntu 12.04 setup tips

## Quartus

### Starting

You must run Quartus from the `bin` directory of your installation directory.

### Using the programmer

You must create a new udev rule to enable the USB-Blaster programmer on the BemicroSDK.

First, do `sudo gedit /etc/udev/rules.d/51-usbblaster.rules` (or your favorite editor)
and paste in the following contents, then save:

    # Enable USBBlaster on Ubuntu (or any distro without usbfs)
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666", NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", RUN+="/bin/chmod 0666 %c"

To allow the above change to take effect, you simply must run

    udevadm control --reload-rules

The rule will automatically be loaded at boot time, so the above command is only needed after you first create the new rule.

## Modelsim

I was unable to get the Altera Installer to work. Instead, I just downloaded the "v10.0d Software Download for Quartus II v12.0", which worked with the below modification to the `setup` script.

### Installing

Due to a shell incompatibility in Ubuntu (uses `dash` instead of `bash` by default), after unzipping the modelsim installer, you must change the first line of the script from

    #!/bin/sh

to

    #!/bin/bash

If you don't, you'll see the following error:

    ./setup: 35: ./setup: Syntax error: "(" unexpected

### Running

To run modelsim, you must run `linux/vsim` from the directory you installed modelsim to. If you try to run `bin/vsim`, it will fail.


