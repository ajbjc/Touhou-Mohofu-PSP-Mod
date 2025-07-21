
#------------------------------------------------------------------------------
#  東方模倣風 ～ Toho Imitation Style.  Makefile
#------------------------------------------------------------------------------

# (r33) PSPs that have been confirmed to work
# 1.00 (earliest FW for psp-1000)
# 3.60 M33 (earliest CFW for psp-2000)
# Operation has been confirmed with the above PSPs.
# I haven't confirmed with any other PSPs, as I think it will probably work.

# Lines in this file with '.' at the end are comments.

#------------------------------------------------------------------------------
# revision setting. Decide on the 東方模倣風 version and name.
#------------------------------------------------------------------------------

TARGET = mohoufu

#RELESE_DATE = 2011/12/04(r39)冬
#RELESE_DATE = 2011/09/04(r38)秋
RELESE_DATE = 2011/12/04

VERSION_MAJOR =39
VERSION_MINOR =1

# PSP XMB settings
# 0 == No title text, XMB background. Release version (e.g. r34).
# 1 == Title text, no XMB background. Update version (e.g. r34u1).
#USE_EBOOT_TITLE = 0
USE_EBOOT_TITLE = 1

# Note: If you add title text, a background cannot be added.

#------------------------------------------------------------------------------
# developing tools setting. Determines the compilation environment for 東方模倣風.
#------------------------------------------------------------------------------

# 0 == Use cygwin (normal development).
# 1 == Use pspsdk-setup-0.11.1.exe (Minimalist PSP homebrew SDK for Windows. version 0.11.1).
# 1 == Use pspsdk-setup-0.11.2r2.exe (2011-05-18).
#// Not yet tested 1 == Use pspsdk-setup-0.11.2r3.exe (2011-06-01).
#USE_MINIMALIST_PSP_SDK = 1
USE_MINIMALIST_PSP_SDK = 0


# Compatible with Minimalist PSP homebrew SDK for Windows. (hereinafter referred to as minimalist) from r34.
# Minimalist's make.exe does not support indentation of control syntax,
# so control syntax cannot be indented in Makefile. (Cygwin's make supports indentation of control syntax.)
# Makefiles up to r33 are indented, so if you want to compile Makefiles up to r33 with minimalist,
# please correct all indentation. (Compilation will not be successful if you do not correct the indentation)
# If you are compiling up to r33 and an error occurs due to differences in GCC specifications,
# please correct the source code of r33u2 or r33u0. (Compare r33 and r33u0)
# The imitation Makefiles make heavy use of nested control syntax, so the Makefiles may be a little difficult to read.
# Up until r33, the policy was to leave unnecessary functions in the Makefile as much as possible (compatible with standard SDL),
# From r34 onwards, the policy has been changed to removing unnecessary functions as much as possible (by unsupporting standard SDL).

# In my (231) environment, the environment variables are set in start.bat (attached), but I don't know about other environments.

#------------------------------------------------------------------------------
# PSP setting.
#------------------------------------------------------------------------------

# Compatible with PSP-2000.
PSP_LARGE_MEMORY = 1

# It seems to be compatible with 3.71 and later (i.e. PSP-2000 extended memory).
PSP_FW_VERSION = 371

# Note: The signed version cannot be started with fw1.00. (BUILD_PRX = 1 is not possible)
#PSP_SYOMEI_OFW = 0
PSP_SYOMEI_OFW = 1

# Note: In the case of (r38) Minimalist, the signed version hangs up when entering Music Room. The cause is insufficient memory,
# but we were unable to find out the cause in time.
# In the case of (r38) cygwin, the signed version does not run out of memory, so there is no problem. It does not hang up when entering Music Room.

#------------------------------------------------------------------------------
# OFW setting.
#------------------------------------------------------------------------------
# Reference http://pspbannoukaizou.blog50.fc2.com/blog-entry-157.html
# 800200D9 Failure to allocate memory block.
# 800200D9 = Failure to allocate memory block (ex. missing PSP)
# 80020148 Unsupported PRX is being used.
# In recovery mode, disable "Advanced configuration" -> "Execute boot.bin in UMD/ISO".
# 80020148 = Unsupported PRX type | This error also seems to appear when you are running an iso with a fake mem. stick

# prx->eboot // Failed to boot (800200D9) (PRX but not enough memory?)
# eboot->eboot // Failed to boot (80020148) (Can't boot because it's not a PRX?)

# The two items ENCRYPT and BUILD_PRX are a pair. Note that recompilation will fail if you have an old *.elf.
ifneq ($(PSP_SYOMEI_OFW),1)
	# 0 == Unsigned version, fw1.00 compatible version
	APP_UTF8_SYMEI_STR = $(APP_UTF8_HI_SYOMEI_BAN)
	# prx->eboot // Failed to start FW1.00 (80020148)
	# fw1.00, is it impossible for prx (???)
	## Do not encrypt.
	#ENCRYPT = 0
	## Do not build with PRX. (Build with EBOOT.PBP)
	#BUILD_PRX = 0
	# If BUILD_PRX = 1, it cannot start with fw1.00.
	# Used in src/game_core/bootmain.c.
	CORE_CFLAGS += -DAPP_SYOMEI_OFW=0
else
	APP_UTF8_SYMEI_STR = $(APP_UTF8_SYOMEI_BAN)
	# 1 == signed version (worked ok with cfw5.00m33-6)
	# Add a signature so it can be started with the official FW.
	## Encrypt.
	#ENCRYPT = 1
	# (???) Build *.prx instead of EBOOT.PBP. (Required if ENCRYPT = 1???)
	## Build with PRX. (Do not build with EBOOT.PBP)
	#BUILD_PRX = 1
	# Use in src/game_core/bootmain.c.
	CORE_CFLAGS += -DAPP_SYOMEI_OFW=1
endif
#BUILD_PRX = 1


#------------------------------------------------------------------------------
# Compile option flag. (Mainly for debugging)
#------------------------------------------------------------------------------

# 1 == Use GNU PROFILER (game core)
#USE_PROFILE = 1
USE_PROFILE = 0

# 1 == Use GNU PROFILER (library) (requires USE_PROFILE = 1)
#USE_LIB_PROFILE = 1
USE_LIB_PROFILE = 0

# 1 == Disable FPU exceptions
USE_FPU_HACK = 1
#USE_FPU_HACK = 0

#------------------------------------------------------------------------------
# Debug information. (For debugging purposes, EBOOT.PBP remains the same even if you change this)
#------------------------------------------------------------------------------
# For debugging purposes. If you want to check the placement of global variables, etc.
#------------------------------------------------------------------------------

# 0 == Do not output symbol placement information for debugging.
# Debug information for when you want to know "specific library dependencies (actual placement)",
# "placement of global variables",
# "actual .align adjustment of data section ("*fill*" is the .align done by GCC)",
# etc.
#DEBUG_MAP = 0
DEBUG_MAP = 1

#------------------------------------------------------------------------------
# Compile option flag.
#------------------------------------------------------------------------------
# SDL library for 模倣風: (2011-02-16) The current SDL for PSP has various bugs. (Even if you use only SDL for drawing, SDL itself has bugs.)
# In the standard SDL for PSP, even if you explicitly specify a software surface, the hardware surface may be used.
# Because the PSP hardware is used in a strange way, processing slows down in strange places. This is unavoidable as long as you use the standard SDL.
# In PSPL, SDL hardware support (GU) has been completely cut. This makes it faster to run because the GPU is not used at strange times.
# In 模倣風, only USE_PSPL = 1 is supported.
#------------------------------------------------------------------------------

# PSPL == A dedicated library of SDL customised for 模倣風.
# PSPL == A special library customising SDL for 模倣風. The behaviour is different from the original SDL, e.g. no initialisation process, etc.)
# Names and constants are SDL something, so you can't use any SDL related things at the same time.
# 1 == USE_PSPL (use SDL (PSPL) for 模倣風)
# 0 == USE_PSPL (standard SDL is 0, unsupported)
USE_PSPL = 1
#USE_PSPL = 0

#------------------------------------------------------------------------------
# Custom Lib option flag. (Customise)
#------------------------------------------------------------------------------
# Note: If you change the options in this category, you must recompile audio_mixer.
# (make rr↓ after changing the settings, then make↓ recommended).
#------------------------------------------------------------------------------
# FAQ. Q: What is "audio_mixer"?
# "audio_mixer" is a modified version of SDL_mixer.a.
# audio_mixer cannot be used alone. (SDL.a is required) The reason is that
# 1. It uses SDL's standard file I/O function.
# 2. It uses SDL's exclusion control function (semaphore). (.IT uses VERCH for buffering, so semaphores are not actually relevant, but ogg has problems with playback.)
# (SDL timers are not used)
# "madlib.a" is required separately to make it compatible with mp3. (Regarding madlib.a, there seems to be no difference in the version for PSP, so it is not attached)
#------------------------------------------------------------------------------
# The main modifications to "audio_mixer" are:
# 1. The version of the mod (mikmod) was old, so I updated it to the latest version (but it's from the last century), and also sped up the loading of .IT format.
# 2. The mixing level setting related to the mod was too small compared to ogg and mp3, so I fixed it. (However, the sound will not distort in a practical range, but there is a possibility that it will)
# 3. The load on the built-in virtual mixer (VERCH==Virtual-Mixer) related to the mod was too high, so I sped it up. (Changed from 64bit to 32bit and fixed the filter)
# 4. I removed unnecessary effector functions (digital reverb) to make it faster.
# (This effect is interesting, but it puts too much strain on the PSP. If it's not a barrage of bullets, it can achieve a practical speed of about 1ch (2ch for stereo).)
# (If you want to, you can use ending-staff roll or something with less strain.)
# 5. There are only 8 sound effect channels, so I made it 16. (Even if I increased it to about 128 channels (currently there are no filters & effects), it would probably put almost no strain on the device.)
# 6. Other unnecessary functions such as reverse playback and loop playback were cut out. (To make it faster.)
# 7. Others (I forgot)
#------------------------------------------------------------------------------

# Experimental
# 0 == CUS TOM_LIB
#CUS TOM_LIB = 1
#CUS TOM_LIB = 0

# MP3 configuration.
# Note: If you change the MP3 availability, you must recompile audio_mixer. (After changing the settings, make rr↓ and then make↓ recommended).

## Note: LINK_SMPEG_MP3 and LINK_MAD_MP3 cannot both be set to 1.
# ok 	LINK_SMPEG_MP3 = 0	LINK_MAD_MP3 = 0	Don't use MP3.
# ok 	LINK_SMPEG_MP3 = 1	LINK_MAD_MP3 = 0	Use smpeg MP3 (up to r30). (Unstable, slow, and has lots of crackling noise)
# ok 	LINK_SMPEG_MP3 = 0	LINK_MAD_MP3 = 1	Use libmad mp3 (r31 or later). (Highly stable, but slow... drops to around 45fps.)
# NG 	LINK_SMPEG_MP3 = 1	LINK_MAD_MP3 = 1	Not possible as there is no support at the source level, NG.

## MP3 in smpeg (up to r30)
# 0 == LINK_SMPEG_MP3: Standard setting [Whether to use MP3 in smpeg] (0: Do not use, 1: Use)
LINK_SMPEG_MP3 = 0
#LINK_SMPEG_MP3 = 1
# There are still bugs in smpeg (※1).
# ※1: Currently known bugs:
# Calling SDL_OpenAudio() within MPEGaudio:: MPEGaudio() (when creating a class) is not good in many ways with the current specifications of SDLmixer.

## MP3 in libmad (r31~)
# 1 == LINK_MAD_MP3: Standard setting [whether to use libmad MP3] (0: not use, 1: use)
#LINK_MAD_MP3 = 0
LINK_MAD_MP3 = 1
# I don't know what's inside madlib, but it's separated from SDLmixer, so if there are no bugs in madlib, it's probably fine.

# r31: I tried various things, but smpeg was unstable (it often died suddenly), so I stopped using smpeg and switched to libmad.
# (Assuming there are no bugs in either) I think it's probably a buffer overrun?

# 1 == LINK_OGG: Standard setting [Whether or not to use ogg] (0: Do not use, 1: Use)
# Note: If you change whether or not to use ogg, you must recompile audio_mixer.
LINK_OGG = 1
#LINK_OGG = 0

# 0 == LINK_LIBTREMOR_LOW_MEM: When using ogg, select which libtremor to use.
# 0: Use libtremor_large.
# 1: Use libtremor_lowmem.
# 0 == LINK_LIBTREMOR_LOW_MEM: Standard setting [Whether to use libtremor_lowmem] (0: Do not use, 1: Use)
# Note: If you change the selection of libtremor_lowmem, you must recompile audio_mixer.
LINK_LIBTREMOR_LOW_MEM = 1
#LINK_LIBTREMOR_LOW_MEM = 0


# "MOD" stands for "Module Music" format.
# Data in this format contains sampled audio and musical notation, and plays the music through real-time synthesis.
# There are four main "Module Music" formats: "*.mod", "*.s3m", "*.xm", and "*.it".
# Of these, the IT format (Impulse Tracker format) is used for 模倣風 sounds.

# I haven't experimented with LINK_MOD = 0 so I don't know.
LINK_MOD = 1

#------------------------------------------------------------------------------
# Configurate Rule.
#------------------------------------------------------------------------------

SRC = src
OBJ = obj

VERSION_ALL = r$(VERSION_MAJOR)u$(VERSION_MINOR)

#CORE_CFLAGS += -DAPP_NAME_STR="KENE"
CORE_CFLAGS += -DAPP_RELEASE_VERSION=$(VERSION_MAJOR)
CORE_CFLAGS += -DAPP_UPDATE_VERSION=$(VERSION_MINOR)

include ./$(SRC)/UTF8_title.mak

#PSP_EBOOT_TITLE = kene_r34_debug
#PSP_EBOOT_TITLE = kene$(RELESE_DATE)(r35)
#PSP_EBOOT_TITLE = kene$(RELESE_DATE)(r34u0)
PSP_EBOOT_TITLE = Touhou Mohofu r40 Mod

ifneq ($(USE_EBOOT_TITLE),1)
	# 0 == Release version (no title text)
	PSP_EBOOT_ICON	 = ICON0.PNG
	PSP_EBOOT_ICON1  = ICON0.PMF
	PSP_EBOOT_UNKPNG = ICON1.PNG
	PSP_EBOOT_PIC1	 = PIC1.PNG
	PSP_EBOOT_SND0	 = SND0.AT3
else
	# If you specify an image for PSP_EBOOT_UNKPNG, the title text will not appear.
	# If you specify an image for PSP_EBOOT_PIC1, the title text will not appear.
	# It's a pain to create ICON1.PNG anyway.
	# 1 == Updated version (with title text)
	PSP_EBOOT_ICON	 = ICON0.PNG
#test	PSP_EBOOT_ICON1  = ICON0.PMF
	PSP_EBOOT_UNKPNG =
	PSP_EBOOT_PIC1	 =
#test	PSP_EBOOT_SND0	 = SND0.AT3
endif

# Regular development
EXTRA_TARGETS		 = mk_dir EBOOT.PBP


ifneq ($(USE_MINIMALIST_PSP_SDK),1)
# Regular development (cygwin)
PSPDEV = $(shell psp-config --pspdev-path)
PSPSDK = $(shell psp-config --pspsdk-path)
else
# pspsdk-setup-0.11.1
PSPDEV = C:/pspsdk/
PSPSDK = C:/pspsdk/psp/sdk/
endif

#------------------------------------------------------------------------------
# Development environment notes.
#------------------------------------------------------------------------------

# In case it should be compatible with any environment
# (↓) The way it is supposed to be written in PSPSDK.
#PSPDEV = $(shell psp-config --pspdev-path)
# (↓) The way it is supposed to be written in PSPSDK.
#PSPSDK = $(shell psp-config --pspsdk-path)
# (↓) The way it is supposed to be written in PSPSDK. (However, if the internal relative path specification of PSPSDK changes, the compilation will not pass.)
#PSPBIN = $(PSPDEV)/psp/bin
# (↓) It's not a very good way to write it, but if you have $(PSPSDK), the compilation will pass even if you don't have $(PSPDEV). (However, if the internal relative path specification of PSPSDK changes, the compilation will not pass.)
#PSPBIN = $(PSPSDK)/../bin

# For cygwin (pspdev) (C:/cygwin/pspdev/)
##PSPDEV = /pspdev
##PSPSDK = /pspdev/psp/sdk
##PSPBIN = /pspdev/psp/bin
##PSPDEV = /usr/local/pspdev
##PSPSDK = /usr/local/pspdev/psp/sdk
##PSPBIN = /usr/local/pspdev/psp/bin

# For cygwin (pspsdk) (C:/cygwin/pspsdk/)
##PSPDEV = /pspsdk
##PSPSDK = /pspsdk/psp/sdk
##PSPBIN = /pspsdk/psp/bin
##PSPDEV = /usr/local/pspsdk
##PSPSDK = /usr/local/pspsdk/psp/sdk
##PSPBIN = /usr/local/pspsdk/psp/bin

# For minimalist (pspsdk) (C:/pspsdk/)
##PSPDEV = C:/pspsdk
##PSPSDK = C:/pspsdk/psp/sdk
##PSPBIN = C:/pspsdk/psp/bin

# (↓) The way it is written, as originally intended by PSPSDK.
#SDL_CONFIG = $(PSPDEV)/psp/bin/sdl-config
# (↓) This is not a very good way to write it. (However, if the internal relative path specification of PSPSDK changes, the compilation will not pass. However, if $(PSPBIN) is changed to match the specification, the compilation will pass.)
#SDL_CONFIG = $(PSPBIN)/sdl-config
# (↓) This is not a very good way to write it, but if $(PSPSDK) is present, the compilation will pass even if $(PSPDEV) is not present. (However, if the internal relative path specification of PSPSDK changes, the compilation will not pass.)
#SDL_CONFIG = $(PSPSDK)/../bin/sdl-config

# sdl-config ( $(shell $(SDL_CONFIG) --libs) ) cannot be used. There are two reasons for this.

# 1. sdl-config has -lSDLmain. If you use this, it will not start on the new PSP (psp-2000).
# For that reason, there is a main(); in addition to the main(); in libSDLmain.a (obviously to start on the PSP-2000).
# Use this (C language has only one main(); function, linker prioritizes last arrival),
# However, there is a risk of conflicts if the names of peripheral functions are the same.

# 2. Dependencies between libraries cannot be resolved.
# Because sdl-config does not take into account cases where dependencies occur with libraries other than SDL.

#------------------------------------------------------------------------------
# Library.
#------------------------------------------------------------------------------

# Reference http://himitsu.jpn.ph/yomimono/linux/staticlink.html
# Reference http://www.hakodate-ct.ac.jp/~tokai/tokai/gtkmm/etc/p1.htm

LIBDIR =
LDFLAGS =


#------------------- for debug.

ifneq ($(DEBUG_MAP),1)
# Normal
else
# Mapping output (for debugging)
LDFLAGS += -Wl,-Map=$(TARGET)_map.txt
endif

#------------------- for debug.

ifneq ($(USE_PROFILE),1)
else
#ifneq ($(USE_LIB_PROFILE),1)
#else
# -lpspprof is position dependent when linking with SDL.
LIBS += -lpspprof
#endif
#	CORE_LIBS += -lpspprof
endif

# If the position is bad
#＜Omitted＞
#er.o obj/game_core/hiscore.o obj/game_core/fps.o obj/game_core/soundmanager.o obj/game_core/bg.o -lS
#DL_noGL -lSDL_mixer -lvorbisidec -lSDL_image -lpng -lz -ljpeg -lm -L/usr/local/p
#spdev/psp/lib -lSDLmain -lSDL -lm -L/usr/local/pspdev/psp/sdk/lib -lpspdebug -lp
#spgu -lpspctrl -lpspge -lpspdisplay -lpsphprm -lpspsdk -lpsprtc -lpspaudio -lc -
#lpspuser -lpsputility -lpspkernel -lpspnet_inet -lpsppower -lpspprof -lpspdebug
#-lpspdisplay -lpspge -lpspctrl -lpspsdk -lc -lpspnet -lpspnet_inet -lpspnet_apct
#l -lpspnet_resolver -lpsputility -lpspuser -lpspkernel -o kene.elf
#psp-fixup-imports kene.elf
#Error, could not fixup imports, stubs out of order.
#Ensure the SDK libraries are linked in last to correct this error
#make: *** [kene.elf] Error 1
# and I can't link it. (I put -lpspprof at the end because it says to put the PSPSDK library at the end...)
#＜Omitted＞
#er.o obj/game_core/hiscore.o obj/game_core/fps.o obj/game_core/soundmanager.o obj/game_core/bg.o -lp
#spprof -lSDL_noGL -lSDL_mixer -lvorbisidec -lSDL_image -lpng -lz -ljpeg -lm -L/u
#sr/local/pspdev/psp/lib -lSDLmain -lSDL -lm -L/usr/local/pspdev/psp/sdk/lib -lps
#pdebug -lpspgu -lpspctrl -lpspge -lpspdisplay -lpsphprm -lpspsdk -lpsprtc -lpspa
#udio -lc -lpspuser -lpsputility -lpspkernel -lpspnet_inet -lpsppower -lpspdebug
#-lpspdisplay -lpspge -lpspctrl -lpspsdk -lc -lpspnet -lpspnet_inet -lpspnet_apct
#l -lpspnet_resolver -lpsputility -lpspuser -lpspkernel -o kene.elf
#make: *** [kene.elf] Interrupt
# You can link like this. (Only the position of -lpspprof is different)

# Not limited to -lpspprof (for example, C:/cygwin/pspdev/psp/sdk/lib/libpspprof.a),
# If "stubs out of order." appears,
# When linking with SDL, linking is not possible due to position dependency.
# You can always link by reviewing the library position in the Makefile,
# but if the problem cannot be resolved due to "$(shell $(SDL_CONFIG) --libs)", it can be quite a mess.


#LIBS_org += -lstdc++		C++ is not used.
#LIBS_org += -lSDL_mixer	Use.
#LIBS_org += -lvorbisidec	Use.
#LIBS_org += -lSDL_image	Use.
#LIBS_org += -lpng			Use.
#LIBS_org += -lz			Use.
#LIBS_org += -ljpeg 		Use.
#LIBS_org += -lSDL_gfx
#LIBS_org += -lm			Use.
#LIBS_org += $(shell $(SDL_CONFIG) --libs)
#LIBS_org += -lpsppower 	Use.


#------------------- ogg codec.
ifneq ($(LINK_OGG),1)
##not include	## If you don't use ogg.
else
##
ifneq ($(LINK_LIBTREMOR_LOW_MEM),1)
##only large
LIBTREMOR_DIR = libtremor_large
else
##only LINK_LIBTREMOR_LOW_MEM
LIBTREMOR_DIR = libtremor_lowmem
endif
##
#ifneq ($(CUS TOM_LIB),1)
#	# If not CUS TOM_LIB
#	LIBS += -lvorbisidec
#else
#LIBS += $(OBJ)/libtremor/lib_mohou_vorbisidec.a
LIBS += $(OBJ)/$(LIBTREMOR_DIR)/lib_mohou_vorbisidec.a
#endif
endif

#------------------- Location dependent link.

#ifneq ($(CUS TOM_LIB),1)
#	# If not CUS TOM_LIB
#	LIBS += -lSDL_image 	Unsupported
#	LIBS += -lpng			Unsupported
#	LIBS += -ljpeg			Unsupported
#	# Standard
#	#LIBS += -lpspmath		Unsupported
#else
#カスタム
#LIBS += $(OBJ)/libpspmath/libpspmath.a
#endif
LIBS += $(OBJ)/vfpu/lib_mohou_vfpu.a

LIBS += -lz

#LIBS += -lm


#-------------------
# libc related.
#-------------------

# Don't use (standard gnu) libc, use (PSPSDK's libpsplibc for psp).
#USE_PSPSDK_LIBC = 1
#For now, I'll stop because I think there may be an environment where I can't compile. (Because I'm linking with -lc at the same time)

# Well, to be honest, it's not good to link both newlib and libpsplibc, but for SDL reasons. (Mainly signal(); )
# (r32)For now, just newlib. (Do not use libpsplibc)
LIBS += -lc

# smpeg is C++, but libstdc++.a is not used.
#LIBS += -lstdc++

#---------------------------

### SDL-related stuff comes first (position dependent)

#---------------------------

#LIBS += $(shell $(SDL_CONFIG) --libs)
# -lSDLmain will cause all sorts of weird stuff. -lSDLmain will not be linked.

#---------------------------

### PSPSDK related stuff later (location dependent)

LIBS += -lpsppower
#LIBS += -lpspgum
#LIBS += -lpspgu
LIBS += -lpsphprm
LIBS += -lpspaudio
LIBS += -lpsprtc

#---------------------------

#LIBS += -lpspdebug
#LIBS += -lpspdisplay
#LIBS += -lpspge
#LIBS += -lpspctrl
#LIBS += -lpspsdk
#LIBS += -lc
#LIBS += -lpspnet
#LIBS += -lpspnet_inet
#LIBS += -lpspnet_apctl
#LIBS += -lpspnet_resolver
#LIBS += -lpsputility
#LIBS += -lpspuser
#LIBS += -lpspkernel

#---------------------------
#bgu_tiny.a obj/libtremor_lowmem/lib_mohou_vorbisidec.a obj/vfpu/lib_mohou_vfpu.a
# -lz -lc -lpsppower -lpsphprm -lpspaudio -lpsprtc -lmad
# -lpspdebug -lpspdisplay
# -lpspge -lpspctrl -lpspsdk -lc -lpspnet -lpspnet_inet -lpspnet_apctl
# -lpspnet_resolver -lpsputility -lpspuser -lpspkernel -o kene.elf


#------------------------------------------------------------------------------
# Object Directory.
#------------------------------------------------------------------------------

OBJDIRS += $(OBJ)
OBJDIRS += $(OBJ)/font

# add after the others, in custom.mak

#------------------------------------------------------------------------------
# Object.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Include makefiles.
#------------------------------------------------------------------------------
# The differences due to version variations of the 模倣風 will be absorbed here.
#------------------------------------------------------------------------------

# Makefile body. (Makefile body and dedicated library)
include $(SRC)/src.mak


#------------------------------------------------------------------------------
# CFLAGS.
#------------------------------------------------------------------------------

##	CFLAGS += -O2
	# For 模倣風, do not specify here. (This option is an optimization setting)

CFLAGS_OPTIMIZE += -O3
#??? Signature test
# Reference: Article updated 2011-02-07 http://nekoyama2gillien.blog36.fc2.com/blog-entry-417.html
# CFLAGS_OPTIMIZE += -O2 -march=allegrex -mips2 -mabi=eabi -mgp32 -mlong32
# Hmm, I don't really get it.


#------------------------------------------------------------------------------
# Reference: http://www.sra.co.jp/wingnut/gcc/gcc-j.html
# Supports GNU CC (GCC) version 2.95. (Japanese draft-17 July 2001)
# Options for MIPS computers
# The following -m options are defined.

# ============================================= cpuの指定
# -mcpu=<cpu type> // This option does not exist as of GCC-4.3.5 for psp.
# Explanation: Specifies the cpu. In recent GCC (4.x.x series), -mcpu has been abolished and replaced with -march.
# Explanation: As of GCC-4.3.5 for psp, -mcpu is not supported.
# -mcpu=<cpu type>
# Assumes the machine default for instruction scheduling is <cpu type>.
# <cpu type> is one of r2000, r3000, r3900, r4000, r4100, r4300, r4400, r4600, r4650, r5000, r6000, r8000, orion.
# Additionally, r2000, r3000, r4000, r5000, r6000 can be abbreviated to r2k (or r2K), r3k, etc.

#------------
# http://www7.atwiki.jp/pspprogram/pages/12.html
# CPU (Allegrex)
# MIPS 32-bit core R4000
# Frequency: 1-333MHz
# Floating-point calculation capability: 2.6Gflops (when running at 333MHz)
# VFPU included
# Convenient constants hard-coded

# The CPU used in the PSP is the 32-bit custom CPU "Allegrex" of MIPS' R4000.
# Compatible clocks are 1-333MHz. It has extended instructions for power saving, and the FPU and VFPU are directly connected.
CPUTYPE = allegrex
#CFLAGS_OPTIMIZE += -march=allegrex
CFLAGS_OPTIMIZE += -march=$(CPUTYPE)
# http://nekoyama2gillien.blog36.fc2.com/blog-date-200911.html
# -march=<cpu type>
# Assume the machine default for instruction scheduling is <cpu type>.
# <cpu type> is
# mips1, mips2, mips3, mips4, mips5,
# mips32, mips32r2, mips64, mips64r2,
# r2000, r3000, r3900, r4000, r4010, r4400, r4600, r4650,
# r6000, r8000, r10000, r12000, orion, allegrex,
# vr4100, vr4111, vr4120, vr4130, vr4181, vr4300, vr5000, vr5400, vr5500,
# rm5200, rm5230, rm5231, rm5261, rm5721, rm7000, rm9000,
# 4kc, 4km, 4kp, 5kc, 20kc, sb1, from-abi
# One of these.
# Explanation: Specifies the architecture (CPU design).
# Explanation: On PSP, it seems to be -march=allegrex.

#------------

# Choosing a particular <cpu type> will schedule appropriately for that particular chip, but will not generate any code that does not fit
# level 1 of the MIPS ISA (Instruction Set Architecture), unless you specify -mipsX or -mabi.

# ============================================= Specifying the MIPS type
# ------ MIPS I/II/III/IV
# -mips1 // (cannot be specified on psp)# error: -mips1 conflicts with the other architecture options, which specify a MIPS2 processor
# -mips2 // (can be specified on psp)# Is the allegrex architecture based on MIPS II? (Is it a modified version of the MIPS II compliant r4000 series?)
# -mips3 // (cannot be specified on psp)# error: -mips3 conflicts with the other architecture options, which specify a MIPS2 processor
# -mips4 // (cannot be specified on psp)# error: -mips4 conflicts with the other architecture options, which specify a MIPS2 processor
#-mips1
# Issues level 1 instructions of the MIPS ISA. This is the default.
# r3000 is the default CPU type for this ISA level.
#-mips2
# Issues level 2 instructions of the MIPS ISA (branch likely, square root instructions).
# r6000 is the default CPU type for this ISA level.
#-mips3
# Issues MIPS ISA level 3 instructions (64-bit instructions).
# r4000 is the default CPU type for this ISA level.
#-mips4
# Issues MIPS ISA level 4 instructions (conditional move instructions, prefetch instructions, enhanced FPU instructions).
# r8000 is the default cpu type for this ISA level.
# CFLAGS_OPTIMIZE += -mips2
# Explanation: Although only -mips2 can be specified on the PSP, it is not the default.
# Note that the handling of the case when it is specified and the case when it is omitted is special.
# The PSP's allegrex is based on MIPS II, but also has some MIPS III instructions.
# So I'm not sure how GCC will handle them if you specify -mips2.

#------------ Sets the number of bits in the FPU registers in the CPU. (Note that VFPU is completely unrelated)
# Explanation: The PC coprocessors (floating point formats) used by Koumakyou are 32bit, 64bit, 96bit (maybe 80bit), and 128bit.
# 32bit is what is called (float).
# 64bit is what is called (double).
# 96bit (80bit?) is (apparently a format called tri double).
# 128bit is what is called (long double).
# The Koumakyou game engine probably only uses 32bit and 64bit,
# but since Direct X and the VisualC++ runtime are statically linked, 96bit (maybe 80bit) and 128bit are used here.
# Direct X (statically linked) also uses SSE and MMX.

# Explanation: -mfp32 uses what is called (float) on PC.
# Explanation: -mfp64 uses what is called (double) on PC. However, this cannot be set on the PSP. If you write double on the PSP, it will use float precision.
#-mfp32
# Assumes that 32 32-bit floating-point registers are available. This is the default.
#-mfp64 // (Cannot be specified on the PSP.) // error: unsupported combination: -mfp64 -msingle-float
# Assumes that 32 64-bit floating-point registers are available. This is the default when the -mips3 option is specified.
CFLAGS_OPTIMIZE += -mfp32

#------------ General purpose register settings in the CPU. # Number of bits per register
#-mgp32
# Assumes that 32 32-bit general purpose registers are available. This is the default.
#-mgp64 // (cannot be specified with psp.) error: '-mgp64' used with a 32-bit processor.
# Assumes that 32 64-bit general purpose registers are available. This is the default when the -mips3 option is specified.
CFLAGS_OPTIMIZE += -mgp32

#------------ Specify the size of long types.
#-mlong32
# Force long, int and pointer types to be 32 bits wide.
# If neither -mlong32, -mlong64 nor -mint64 is specified, the sizes of int, long and pointer depend on the ABI and selected ISA.
# With -mabi=64, ints are 32 bits wide and longs are 64 bits wide.
# With -mabi=eabi, and if -mips1 or -mips2 is specified, ints and longs are 32 bits wide.
# With -mabi=eabi, and if a higher ISA is specified, ints are 32 bits wide and longs are 64 bits wide.
# The width of pointer types is the smaller of the width of a long and the width of a general register (this depends on the ISA).
#-mlong64
# Force long types to be 64 bits wide. See -mlong32 for an explanation of the default and pointer sizes.
#-mint64
# Forces long and int types to be 64 bits wide. See -mlong32 for an explanation of the default and pointer sizes.
# Explanation: On the PSP, -mlong32 will not compile applications that require 64-bit longs. I think Timidity and other applications will not compile unless -mlong64 is used.
# Explanation: Long longs are not affected by these options and are probably 64-bit on the PSP, so it doesn't seem to matter, but I'm not sure.
CFLAGS_OPTIMIZE += -mlong32

#-mabi=32
#-mabi=o64 // (Maybe not possible on psp)
#-mabi=n32 // (Maybe not possible on psp)
#-mabi=64
#-mabi=eabi
# Generate code for the specified ABI.
# The default instruction level is -mips1 for 32,
# -mips3 for n32, and -mips4 for the rest.
# Conversely, if you specify -mips1 or -mips2, the default ABI will be 32, and 64 for the rest.
CFLAGS_OPTIMIZE += -mabi=eabi

#-mmips-as
# Generate code for the MIPS assembler and run mips-tfile to add the usual debug information.
# This is the default for all platforms except the OSF/1 reference platform, which uses the OSF/rose object format.
# Using either the -gstabs or -gstabs+ option causes the mips-tfile program to wrap stabs format debug information in a MIPS ECOFF.
#-mgas
# Generate code for the GNU assembler. This is the default for OSF/1 reference platforms, which use the OSF/rose object format.
# Also the default when the configure option --with-gnu-as is specified.

#-msplit-addresses
#-mno-split-addresses
# Generate code to load the high and low parts of address constants separately.
# This allows gcc to optimize away unnecessary loading of high order address bits.
# This optimization requires GNU as and GNU ld. This optimization is enabled by default for some embedded targets for which GNU as and GNU ld are the standard tools.
#-mrnames
#-mno-rnames
# -mrnames outputs code using MIPS software names for registers instead of their hardware names (e.g. a0 instead of $4).
# The only assembler that supports this option is the Algorithmics assembler.
#-mgpopt
#-mno-gpopt
# -mgpopt writes all data declarations before the instructions in the text section.
# This allows the MIPS assembler to generate one-word memory references instead of two for small global and static data items.
# This is enabled by default if optimization is specified.
#-mstats
#-mno-stats
# The -mstats option will print a line to standard error for each non-inline function processed,
# displaying program statistics (number of registers saved, stack size, etc.).
#-mmemcpy
#-mno-memcpy
# The -mmemcpy option will cause all block moves to call the appropriate string function (memcpy or bcopy)
# instead of generating inline code.
#-mmips-tfile
#-mno-mips-tfile
# -mno-mips-tfile will not post-process the object file after the MIPS assembler adds debug information
# with the mips-tfile program.
# If mips-tfile is not run, local variable information will not be available from the debugger.
# In addition, the stage2 and stage3 objects have the temporary file name passed to the assembler embedded in the object file.
# This ensures that no stage2 object is the same as a stage3 object.
# The -mno-mips-tfile option is only useful if the mips-tfile program has a bug that prevents compilation.

#-msoft-float
# Generate output with floating-point library calls.
# WARNING: the required libraries are not part of GCC.
# Normally the machine's normal C compiler would be used, but this is not possible when cross-compiling.
# If you are cross-compiling, you must provide the appropriate library functions yourself.
#-mhard-float
# Generate output with floating-point instructions. This is the default unless you modify the GCC sources.

#-mabicalls
#-mno-abicalls
# Generate (or do not generate) the pseudo-ops .abicalls, .cpload, and .cprestore used in the System V.4 port for position independent code.

#-mlong-calls
#-mno-long-calls
# Make all calls with the JALR instruction. This requires that the address of the function be loaded into a register before the call.
# This option is necessary if you are calling functions outside the current 512 megabyte segment, not via a pointer.

#-mhalf-pic
#-mno-half-pic
# Forces pointers to external references to be loaded in the data section, rather than in the text section.

#-membedded-pic
#-mno-embedded-pic
# Generate PIC code suitable for some embedded systems. All calls are made using PC-relative addresses,
# and all data is addressed using the $gp register.
# This requires GNU as and GNU ld, which do most of the work for it.
# This currently only works on targets using ECOFF, not ELF.

#-membedded-data
#-mno-embedded-data
# Allocate variables in the read-only data section first, if possible.
# Then allocate them in the small data section, if possible, otherwise put them in the data section.
# This results in code that is somewhat slower than the default, but requires less RAM at run time,
# which may be desirable for some embedded systems.

#-msingle-float
#-mdouble-float
# The -msingle-float option assumes that the floating-point coprocessor only supports single precision arithmetic, such as the r4650 chip.
# The -mdouble-float option forces double precision arithmetic to be used. This is the default.

#-mmad
#-mno-mad
# Allows the use of mad, madu, and mul instructions as with the r4650 chip.

#-m4650
# Enables -msingle-float, -mmad, and, at least for now, -mcpu=r4650.

#-mips16
#-mno-mips16
# Enables 16-bit instructions.

#-mentry
# Uses the pseudo-instructions entry and exit. This option can only be used with -mips16.

# ------- endian (psp is -EL Little Endian.)
#-EL
# Compile code for a processor in little endian mode. Assumes that required libraries are present.
#-EB // (cannot be specified for psp.)
# Compile code for a processor in big endian mode. Assumes that required libraries are present.
# Explanation: psp's cpu is little endian, so -EL (Little Endian). This is the default, so there is no point in specifying it.

#-G<number>
# Place global and static data items that are <number> bytes or less in size
# into the small data and small bss sections instead of the normal data and bss sections.
# This allows the assembler to generate one-instruction memory references based on the global pointer (gp or $28)
# instead of the usual two-instruction memory references.
# The default value of <number> is 8 when using the MIPS assembler, and 0 when using the GNU assembler.
# The -G<number> option is also passed to the assembler and linker.
# All modules must be compiled with the same value of -G<number>.
# Explanation: The psp uses the GNU assembler, so the default is probably -G0.
#CFLAGS += -G8

# ------- Do not use preprocessor for assembler
#-nocpp
# Tells the MIPS assembler not to run the assembler preprocessor when assembling user assembler source files (those with a .s suffix).
# These options are defined in the TARGET_SWITCHES macro in the machine description.
# The defaults for these options are also defined in this macro, so you can change the defaults.

# =============================================

#------------------------------------------------------------------------------


#//??? If you use the -O2 optimization option, you also need to use -Olimit 3000.
#//??? Both of these options are automatically added to the Makefile that configure builds.
#//??? To override the make variable CC to use the MIPS compiler, you need to add -Wf,-XNg1500 -Olimit 3000.


#------------------------------------------------------------------------------
# Code quality
#

## PSP won't work if the alignment is wrong, so set it just to be safe.
# Functions are aligned to 32[byte] boundaries.
CFLAGS += -falign-functions=32
# Loop heads are always aligned.
CFLAGS += -falign-loops
# Labels are always aligned.
CFLAGS += -falign-labels
# Jump destinations are always aligned.
CFLAGS += -falign-jumps

#------------------------------------------------------------------------------



CFLAGS += -Wall
	# Print all warnings if any.
	# In the 模倣風, it uses -Werror, so warnings are treated as errors and compilation is immediately stopped.

CFLAGS += -G0
	# If you specify -G0, (gp==$28) indirect addressing instructions using registers will not be used (probably)
	# Reference http://wfasim.dyndns.org/wordpress/?p=182
# -G<number> is an option related to the GP register. <number> is the number of bytes.
# It allows memory reference using the data section (or bss section) and the GP register (==$28).
# Explanation: In GCC, it seems that -G<number> does not work properly unless it is consistent for all libraries/objects.
# Despite this, libraries/objects with different -G<number> can be linked,
# and there is no way to detect with what -G<number> setting they were compiled.
# In the case of PSP, if a library/object compiled with something other than -G0 is mixed in the library,
# that library/object part will not work properly.
# It is usually better to specify -G0 to be on the safe side.
# However, if you do not use any external libraries/objects (obviously you will compile them yourself if you use PSPSDK), -G8 is possible.

# -G is an option related to the GP register and -g is an option related to debugging. Uppercase and lowercase have completely different meanings.
#??? CFLAGS += -g
# CFLAGS += -g
# -g is a debugging option. I understand that, but I don't really understand the details. (I wonder if adding -pg will be interpreted as adding -g?)
# If you use C++ (smpeg), you may need -g. Or rather, I think you need it.
# Adding -g will make the code slightly larger. (Slightly: 36[bytes] in the case of r33)
# As of r33, there is no C++ imitation, so -g is not necessary. (-lstdc++ is not necessary either)

CFLAGS += -std=gnu99
	# Use C code that complies with the 1999 GNU standard. (Implicit omissions, handling of void pointers, etc.)

# Debug CFLAGS += -Werror
	# If a warning occurs, treat it as an error and stop compiling.

## CFLAGS += -fomit-frame-pointer
	# For imitation, do not specify here. Set the frame pointer later, as it will prevent the profiler from using it.


# Optimization settings for expression types in C/C++ http://www.radiumsoftware.com/0304.html
# CFLAGS += -fstrict-aliasing
	# Optimizes memory access for speed if this option is specified. (May not work if you are not careful with casts, fast)
	# Automatically applied with -O2 $(CFLAGS_OPTIMIZE).
# CFLAGS += -fno-strict-aliasing
	# Optimizes memory access for speed if this option is not specified. (Safe, slow)
# If nothing is specified, -O2 $(CFLAGS_OPTIMIZE) is "-fstrict-aliasing" (May not work if you are not careful with casts, fast)
##### GCC description below
	# Allows the compiler to assume the strictest aliasing rules applicable to the language being compiled.
	# # This allows C (and C++) to perform optimizations based on the type of expressions.
	# For example, it is assumed that an object of one type will not be located at the same address as an object of another type, unless
	# the two types are nearly identical.
	# For example, an unsigned int can alias an int, but it cannot alias a void* or a double.
	# Also, a character type can alias any other type. Watch out in particular for code like this:
	# It is common to read from a different member of a union than the one last written to (known as "type-punning").
	# Even with `-fstrict-aliasing', type-punning is permitted if the memory is accessed through a union type.



# I haven't checked everything, but this is a setting for when to treat it as a warning. (Probably)
	# In the 模倣風, it is -Werror, so if it is a warning, it will be treated as an error and compilation will be stopped immediately.


# Sign comparison is off for now since we are debugging. (Actually, it's not good.)
# off (do not warn on sign comparison): handling of sign comparison
#CFLAGS += -Wno-sign-compare
# on (warn on sign comparison): handling of sign comparison.
CFLAGS += -Wsign-compare



CFLAGS += -Wunused
CFLAGS += -Wpointer-arith
CFLAGS += -Wundef
CFLAGS += -Wformat
CFLAGS += -Wwrite-strings
CFLAGS += -Wdisabled-optimization
CFLAGS += -Wbad-function-cast

#CFLAGS += -Wmissing-prototypes # A warning (→ error) is generated if there is no prototype declaration.

CFLAGS += -ffast-math
	# This option allows GCC to violate certain ANSI and IEEE rules and specifications in order to optimize execution speed.
	# For example, this option makes GCC assume that arguments to the sqrt function are never negative,
	# and that floating-point values are never NaN.




#	CFLAGS += -pipe
#	CFLAGS += -freorder-blocks
#	CFLAGS += -fprefetch-loop-arrays

#------------------------------------------------------------------------------
# Optimization options for loop unrolling
#------------------------------------------------------------------------------
# Adding these options will slow down the program on the PSP.
#------------------------------------------------------------------------------

# ========
# -fstrength-reduce
# Performs loop strength reduction and iteration variable elimination optimizations.
# Moves computations that can be taken out of loops to reduce the number of steps.
# ========
# -frerun-cse-after-loop
# Runs common subexpression elimination again after loop optimizations.
# Does the same thing as -fstrength-reduce.
# ========
# -frerun-loop-opt
# Does the most thorough loop optimizations. Does the same thing as -fstrength-reduce.
# Checks for expressions and address calculations that do not change within loops.
# Then moves such calculations out of loops and stores their evaluation in registers.
# ========
# -funroll-loops
# Performs loop unrolling optimizations.
# This is only done for loops whose iteration count can be determined at compile time or run time.
# -funroll-loops includes -fstrength-reduce and -frerun-cse-after-loop mentioned above.
# ========
# -funroll-all-loops
# Performs loop unrolling optimization. This is done for all loops,
# which usually slows down program execution.
# (On the psp, the more loop unrolling you do, the slower it becomes.) CFLAGS += -funroll-all-loops
# =========


#------------------------------------------------------------------------------
# Cygwin can compile without Minimalist(?).
#CFLAGS += -I/usr/local/pspdev/psp/include
# (mystery)
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#For some reason, it doesn't compile if Minimalist is included(????).
#INCDIR += $(PSPDEV)/psp/include
# (mystery)
#------------------------------------------------------------------------------

#INCDIR += $(PSPSDK)/../include

ifneq ($(USE_PSPL),1)
	# Other than USE_PSPL
	#OPTION_CFLAGS += -I/pspdev/psp/include/SDL
	INCDIR += $(PSPDEV)/psp/include/SDL
	#INCDIR += $(PSPSDK)/../include/SDL
endif


# http://www.sra.co.jp/wingnut/gcc/gcc-j.html
# -fomit-frame-pointer For functions that do not require a frame pointer, the frame pointer is not stored in a register.
# This eliminates the need to save, set, and restore the frame pointer.
# Also, one more register is available for many functions.
# Also, debugging is not possible on some models. (-pg cannot be used on PSP).

# (Currently off due to r36 malfunction. Will it slow down on PSP?) CFLAGS += -ftracer
# (Currently off due to r36 malfunction. Will it slow down on PSP?) CFLAGS += -fstrength-reduce

# I haven't tested which option is worse, but in r36,
# adding these causes the character selection screen to flicker and other strange things.
# These options seem to unroll loops,
# and as the size increases, it will not fit in the cache and will slow down on PSP.

ifneq ($(USE_PROFILE),1)
#	CORE_CFLAGS += -ftracer
#	CORE_CFLAGS += -fstrength-reduce
	CORE_CFLAGS += -fomit-frame-pointer
else
	CORE_CFLAGS += -DENABLE_PROFILE
	CORE_CFLAGS += -pg
endif

ifneq ($(USE_LIB_PROFILE),1)
#	LIB_CFLAGS += -ftracer
#	LIB_CFLAGS += -fstrength-reduce
	LIB_CFLAGS += -fomit-frame-pointer
else
	LIB_CFLAGS += -DENABLE_PROFILE
	LIB_CFLAGS += -pg
endif

# $(shell $(SDL_CONFIG) --cflags)
###
#CXXFLAGS += $(CFLAGS)
#CXXFLAGS += -fno-exceptions
#CXXFLAGS += -fno-rtti
#CXXFLAGS += -fsingle-precision-constant
#CXXFLAGS += -mno-check-zero-division
###
#CXXFLAGS += $(CFLAGS)
#CXXFLAGS += -fno-exceptions
#CXXFLAGS += -fno-rtti
###
#CXXFLAGS += -fno-builtin-printf
###
#ASFLAGS = $(CFLAGS)

CXXFLAGS += $(CFLAGS)
CXXFLAGS += -fno-exceptions
CXXFLAGS += -fno-rtti



#------------------------------------------------------------------------------
# build.mak.
#------------------------------------------------------------------------------

include $(PSPSDK)/lib/build.mak

#---------------------------------------------------------------------
# Rules to make libraries.
#---------------------------------------------------------------------
# I don't know why, but for libraries (*.a),
# if you write it in the *.mak included file, the Makefile won't do it, so write it here.
#---------------------------------------------------------------------

# build ogg lib.
#$(OBJ)/libtremor/lib_mohou_vorbisidec.a: $(TREMOR_OBJS)
$(OBJ)/$(LIBTREMOR_DIR)/lib_mohou_vorbisidec.a: $(TREMOR_OBJS)

# build vfpu lib.
$(OBJ)/vfpu/lib_mohou_vfpu.a: $(LIB_PSP_MATH_OBJS)

# build gu lib.
$(OBJ)/libgu/libgu_tiny.a: $(LIB_PSP_GU_OBJS)

# build debug lib.
$(OBJ)/debug/debug.a: $(LIB_PSP_DEBUG_OBJS)

#---------------------------------------------------------------------
# Rules to manage files.
#---------------------------------------------------------------------

# warnings with malloc free.
#$(OBJ)/jpeg/%.o: $(SRC)/jpeg/%.c
#   psp-gcc $(CFLAGS_OPTIMIZE) $(CFLAGS) -c $< -o $@

# warnings with malloc free.
#$(OBJ)/libpng/%.o: $(SRC)/libpng/%.c
#   psp-gcc $(CFLAGS_OPTIMIZE) $(CFLAGS) -c $< -o $@

# warnings with malloc free.
#$(OBJ)/SDL_image/IMG_png.o: $(SRC)/SDL_image/IMG_png.c
#   psp-gcc $(CFLAGS_OPTIMIZE) $(CFLAGS) -c $< -o $@


#rc/libtremor/misc.h(209) : warning: implicit declaration of function '_ilog'
#rc/libtremor/misc.h(209) : warning: implicit declaration of function 'abs'
# warnings

# For CPP game core, use c++ (change how libraries and gnu profiler are handled).
#$(OBJ)/game_core/%.o: $(SRC)/game_core/%.cpp
#   psp-gcc $(CFLAGS_OPTIMIZE) $(CXXFLAGS) $(CORE_CFLAGS) -c $< -o $@

# For now, smpeg is unsupported (frozen until the bug is fixed).
# For MP3 library (only smpeg is c++)
#$(OBJ)/%.o: $(SRC)/%.cpp
#   psp-gcc $(CFLAGS_OPTIMIZE) -Werror $(CXXFLAGS) $(LIB_CFLAGS) -c $< -o $@

# For OGG (alloca(); warnings).
#$(OBJ)/libtremor/%.o: $(SRC)/libtremor/%.c
$(OBJ)/$(LIBTREMOR_DIR)/%.o: $(SRC)/$(LIBTREMOR_DIR)/%.c
	psp-gcc $(CFLAGS_OPTIMIZE) -Werror $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@

# For C game core (change how libraries and gnu profiler are handled).
$(OBJ)/game_core/%.o: $(SRC)/game_core/%.c
	psp-gcc $(CFLAGS_OPTIMIZE) -Werror $(CFLAGS) $(OPTION_CFLAGS) $(CORE_CFLAGS) -c $< -o $@

# For old png.
#$(OBJ)/png/%.o: $(SRC)/png/%.c
#   psp-gcc -O2 -Werror $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@

# For audio_mixer.
$(OBJ)/PSPL/audio/mixer/%.o: $(SRC)/PSPL/audio/mixer/%.c
	psp-gcc $(CFLAGS_OPTIMIZE) -Werror $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@

# For test libraries.
#$(OBJ)/SDL231/video/%.o: $(SRC)/SDL231/video/%.c
#   psp-gcc $(CFLAGS_OPTIMIZE) $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@

# For now, since an error occurs. (???????).
#$(OBJ)/PSPL/video/PSPL_pspvideo.o: $(SRC)/PSPL/video/PSPL_pspvideo.c
#   psp-gcc $(CFLAGS_OPTIMIZE) $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@

# An error occurs, so for now.
$(OBJ)/PSPL/video/PSPL_bmp.o: $(SRC)/PSPL/video/PSPL_bmp.c
	psp-gcc $(CFLAGS_OPTIMIZE) $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@

# An error occurs, so for now. (???????).
$(OBJ)/PSPL/video/PSPL_video.o: $(SRC)/PSPL/video/PSPL_video.c 
	psp-gcc $(CFLAGS_OPTIMIZE) $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@


# For other libraries.
$(OBJ)/%.o: $(SRC)/%.c
	psp-gcc $(CFLAGS_OPTIMIZE) -Werror $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@

# For assembler.
$(OBJ)/%.o: $(SRC)/%.S
	psp-gcc $(CFLAGS_OPTIMIZE) -Werror $(CFLAGS) $(LIB_CFLAGS) -c $< -o $@

#	psp-gcc $(CFLAGS_OPTIMIZE) -Werror $(CFLAGS) -c $< -o $@
#	psp-gcc $(CFLAGS_OPTIMIZE) -Werror $(CXXFLAGS) -c $< -o $@

# To archive (assemble) a library. (Archive == Create an uncompressed archive)
$(OBJ)/%.a:
	@echo Archiving $@...
	@$(AR) -r $@ $^



#cc1: warnings being treated as errors
#src/PSPL/video/PSPL_pspvideo.c: In function 'vidmem_alloc':
#src/PSPL/video/PSPL_pspvideo.c(187) : warning: cast from function call of type 'void *' to non-matching type 'long unsigned int'
#src/PSPL/video/PSPL_pspvideo.c: In function 'PSP_GuStretchBlit':
#src/PSPL/video/PSPL_pspvideo.c(278) : warning: pointer of type 'void *' used in arithmetic
#src/PSPL/video/PSPL_pspvideo.c(285) : warning: pointer of type 'void *' used in arithmetic
#src/PSPL/video/PSPL_pspvideo.c(286) : warning: pointer of type 'void *' used in arithmetic
#src/PSPL/video/PSPL_pspvideo.c(313) : warning: pointer of type 'void *' used in arithmetic
#src/PSPL/video/PSPL_pspvideo.c: In function 'PSP_VideoQuit':
#src/PSPL/video/PSPL_pspvideo.c(615) : warning: pointer of type 'void *' used in arithmetic
#make: *** [obj/PSPL/video/PSPL_pspvideo.o] Error 1


#cc1.exe: warnings being treated as errors
#src/PSPL/video/PSPL_pspvideo.c: In function 'vidmem_alloc':
#src/PSPL/video/PSPL_pspvideo.c:167: error: cast from function call of type 'void *' to non-matching type 'long unsigned int'
#C:\PSPSDK\BIN\MAKE.EXE: *** [obj/PSPL/video/PSPL_pspvideo.o] Error 1


#------------------------------------------------------------------------------
# Utilities.
#------------------------------------------------------------------------------
# cygwin: A tool to run a virtual unix under windows. It has a reputation for being slow^^;.

#(Note that you cannot indent by inserting a tab here)
#ifeq ($(PSPDEV),)
# Minimalist ???
#else
# 0==Normal development (cygwin)
#endif

ifneq ($(USE_MINIMALIST_PSP_SDK),1)
# Regular development (cygwin)
# (unix: directory, msdos: directory, windows: folder) [The name differs depending on the OS, but it's the same thing]
# make directory (unix:mkdir, msdos:md) make-dir, make-directory (create a directory)
# In 435, it's in build.mak. MKDIR = mkdir.exe
RM = -rm
# copy (unix:cp ,msdos: copy) Copy (duplicate a file) [increases to two]
# In 435, it is in build.mak. CP = cp
CP = cp
# re-move (unix:rm, msdos:del) Remove (delete a file)
# In 435, it is in build.mak. RM = rm
# move (unix:mv, msdos:move) Move (move a file) [The source is deleted]
MV = mv
# archiver Archiver (a tool that compiles and disassembles .obj files compiled in C language, etc., into library .a files. Does not compress files at all)
# In 435, it is in build.mak. (psp-ar)AR = ar
MKDIR = mkdir
else
# pspsdk-setup-0.11.1
#Minimalist PSP homebrew SDK for Windows. (hereafter abbreviated as Minimalist)
# I don't know about this one (Probably Minimalist is this one)
# Minimalist actually runs on cygwin (simplified version) so it's basically the same.
# However, make.exe and other things that require speed don't seem to be related to cygwin and run natively.
#MKDIR = -mkdir
#RM = -rm
MKDIR = mkdir
#RM = -rm.exe
RM = rm
#MV = mv
endif

# Ability to automatically create obj directory.
mk_dir:
	@echo Making directry for $(TARGET) ...
	@$(MKDIR) -p $(subst //,\,$(sort $(OBJDIRS)))
	@$(RM) -f PARAM.SFO

ifneq ($(USE_MINIMALIST_PSP_SDK),1)
# Regular development (cygwin)
DELTREE_OBJ_ALL 	= @$(RM) -f -rd $(OBJ)
DELTREE_AUDIO_MIXER	= @$(RM) -f -rd $(OBJ)/audio_mixer
DELTREE_OBJ_CORE	= @$(RM) -f -rd $(OBJ)/game_core
DELTREE_OBJ_JIKI	= @$(RM) -f -rd $(OBJ)/game_core/jiki
else
# pspsdk-setup-0.11.1
DELTREE_OBJ_ALL 	= $(RM) -f -r -d $(OBJ)
DELTREE_AUDIO_MIXER	= $(RM) -f -r -d $(OBJ)/audio_mixer
DELTREE_OBJ_CORE	= $(RM) -f -r -d $(OBJ)/game_core
DELTREE_OBJ_JIKI	= $(RM) -f -r -d $(OBJ)/game_core/jiki
#C:\pspsdk\srcr34>rm --help
#Usage: C:\PSPSDK\BIN\RM.EXE [OPTION]... FILE...
#Remove (unlink) the FILE(s).
#
#  -d, --directory       unlink directory, even if non-empty (super-user only)
#  -f, --force           ignore nonexistent files, never prompt
#  -i, --interactive     prompt before any removal
#  -r, -R, --recursive   remove the contents of directories recursively
#  -v, --verbose         explain what is being done
#      --help            display this help and exit
#      --version         output version information and exit
#
# When I try to delete a directory, no matter what I specify, I get the message ``No such file or directory.''
# As for C:\PSPSDK\BIN\RM.EXE, it doesn't work properly on my system, so I'm not sure.
endif


# For recompiling audio mixer only.
# Make mixer ↓ (but cygwin)
mixer:
	@echo Remove audio mixer files.
	@$(DELTREE_AUDIO_MIXER)

# Game core only, for recompiling.
# Make core ↓ (but cygwin)
core:
	@echo Remove shooting core files.
	@$(DELTREE_OBJ_CORE)

# Game core player only, for recompiling.
# Make jiki ↓ (but cygwin)
jiki:
	@echo Remove shooting core jiki files.
	@$(DELTREE_OBJ_JIKI)

# Collision detection debug function, for recompiling. (Set in game_main.h)
# Make a ↓ (but cygwin)
a:
	@echo Remove atari debug files.
	@$(RM) -f $(OBJ)/game_core/jiki/jiki.o
	@$(RM) -f $(OBJ)/game_core/jiki/jiki_shot.o
	@$(RM) -f $(OBJ)/game_core/jiki/jiki_bomber.o
	@$(RM) -f $(OBJ)/game_core/my_math.o
	@$(RM) -f $(OBJ)/game_core/sprite_bullet.o
	@$(RM) -f $(OBJ)/game_core/score_panel.o

#	@$(RM) -f $(OBJ)/game_core/*.o
#	@$(RM) -f $(OBJ)/game_core/boss/*.o
#	@$(RM) -f $(OBJ)/game_core/douchu/*.o
#	@$(RM) -f $(OBJ)/game_core/draw/*.o
#	@$(RM) -f $(OBJ)/game_core/menu/*.o
#	@$(RM) -f $(OBJ)/game_core/tama/*.o

# Patch for doing syomei ban in minimalist mode.
patch:
	@echo syomei ban minimalist patch.
	@$(RM) -f $(OBJ)/game_core/boot_main.o
	@$(RM) -f $(TARGET).prx
	@$(RM) -f $(TARGET).elf
	@$(RM) -f PARAM.SFO
	@$(RM) -f EBOOT.PBP


# If you want to recreate gu.
# Make gu ↓ (but only for cygwin)
gu:
	@echo Remove custom font files.
	@$(RM) -f $(OBJ)/game_core/draw/*.o

# If you want to recreate the font.
# Make font ↓ (only for cygwin)
font:
	@echo Remove custom font files.
	@$(RM) -f $(OBJ)/font/*.o


# If you want to delete all obj anyway.
# Make rr ↓ (but on cygwin) (rr stands for Remove all object for Release.)
rr:
	@echo Remove all temporaly files.
	@$(RM) -f PARAM.SFO
	@$(RM) -f *.elf
	@$(RM) -f $(TARGET)_map.txt
	@$(DELTREE_OBJ_ALL)
