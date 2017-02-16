AM_CFLAGS = -O2 -std=c99 -Wall -Wextra -Wshadow -Wno-unused-parameter $(MFLAGS) $(STACKREALIGN)

AM_CPPFLAGS = $(VapourSynth_CFLAGS)

lib_LTLIBRARIES = libtcomb.la

libtcomb_la_SOURCES = src/tcomb.c

if TCOMB_X86
libtcomb_la_SOURCES += src/simd_sse2.c
endif

libtcomb_la_LDFLAGS = -no-undefined -avoid-version $(PLUGINLDFLAGS)
