# Introduction

This repository contains files to generate a bootable SD card image of Haiku for BeagleBoard-xM, written as a part of
the Google Summer of Code 2014 work on the ARM port.

# Instructions
1. Build the bootstrap image for ARM using jam.
2. Clone the repository within the generated.arm directory.
3. Run the script gen_sd_card_image.sh from within the clone repository.
4. The script will automatically generate the SD card image and run qemu.

# Requirements
- mtools(provides mpartition and mformat)
- u-boot tools(provides mkimage)
- qemu(the linaro fork: http://git.linaro.org/git/qemu/qemu-linaro.git)
