# Touhou-Mohofu-PSP-Mod

Mod of Touhou Mohofu r40 that's designed to translate and modernize the homebrew.

How to compile:
Install PSPSDK, via the instructions [here](https://pspdev.github.io/installation.html) using the platform you are using. Once installed, navigate to the directory with the Makefile in whichever console you used to install pspsdk, i.e. WSL, and run ```make```. If done correctly, you should get 4 files:

- EBOOT.PBP
- mohoufu.elf
- mohofu_map.txt
- PARAM.SFO

# Usage

Copy the data folder and the newly built EBOOT.PBP file to the PSP/GAME folder in your PSP or PPSSPP emulator.

# Notes

When running in PPSSPP, under the Graphics settings, set Backend to OpenGL, and turn Software rendering on, otherwise many of the assets will not appear.

When running on a real PSP, a bright, glitchy looking screen will appear for about a second before the game loads. I am not sure what causes this. Make sure to check the Makefile configuration to make sure it's setup for your PSP and firmware.