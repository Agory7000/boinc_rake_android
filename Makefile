# This should work on Linux.  Modify as needed for other platforms.

BOINC_DIR = ../..
BOINC_SOURCE_API_DIR = $(BOINC_DIR)/api
BOINC_SOURCE_LIB_DIR = $(BOINC_DIR)/lib
BOINC_SOURCE_ZIP_DIR = $(BOINC_DIR)/zip
FREETYPE_DIR = /usr/include/freetype2

ifdef ANDROID
  BOINC_API_DIR = $(TCINCLUDES)/lib
  BOINC_LIB_DIR = $(TCINCLUDES)/lib
  BOINC_ZIP_DIR = $(TCINCLUDES)/lib

  MAKEFILE_LDFLAGS = 
  MAKEFILE_STDLIB  = 
else
  BOINC_API_DIR = $(BOINC_SOURCE_API_DIR)
  BOINC_LIB_DIR = $(BOINC_SOURCE_LIB_DIR)
  BOINC_ZIP_DIR = $(BOINC_SOURCE_ZIP_DIR)

  MAKEFILE_LDFLAGS = -lpthread libstdc++.a
  MAKEFILE_STDLIB  = libstdc++.a
endif

CXXFLAGS += -g \
	-Wall -W -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -fno-common \
    -DAPP_GRAPHICS \
    -I$(BOINC_DIR) \
    -I$(BOINC_SOURCE_API_DIR) \
    -I$(BOINC_SOURCE_LIB_DIR) \
    -I$(BOINC_SOURCE_ZIP_DIR) \
    -I$(FREETYPE_DIR) \
    -L$(BOINC_API_DIR) \
    -L$(BOINC_LIB_DIR) \
    -L/usr/X11R6/lib \
    -L.

# to get the graphics app to compile you may need to install some packages
# e.g. ftgl-devel.x86_64
#
# You may have to change the paths for your system.

ifeq ($(wildcard /usr/local/lib/libglut.a),)
	LIBGLUT = /usr/local/lib/libglut.a
	LIBGLU = /usr/local/lib/libGLU.a
	LIBJPEG = /usr/local/lib/libjpeg.a
else
# NOTE: to make your app portable you'll need the static (.a) versions
# of libglut, libGLU, and libjpeg.
# You may have to build these from source.
	#LIBGLUT = /usr/lib64/libglut.a
	#LIBGLU = /usr/lib64/libGLU.a
	#LIBJPEG = /usr/lib64/libjpeg.a
	LIBGLUT = -lglut
	LIBGLU = -lGLU
	LIBJPEG = -ljpeg
endif

PROGS = rakesearch
# uc2_graphics
# make this optional so compile doesn't break on systems without OpenGL

all: $(PROGS)

libstdc++.a:
	ln -s `$(CXX) -print-file-name=libstdc++.a`

ttfont.cpp:
	ln -s ../../api/ttfont.cpp .

clean: distclean

distclean:
	/bin/rm -f $(PROGS) *.o libstdc++.a

install: rakesearch

# specify library paths explicitly (rather than -l)
# because otherwise you might get a version in /usr/lib etc.

rakesearch: main.o Square.o RakeSearch.o $(MAKEFILE_STDLIB) $(BOINC_API_DIR)/libboinc_api.a $(BOINC_LIB_DIR)/libboinc.a
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) -o rakesearch main.o Square.o RakeSearch.o -pthread \
	-lboinc_api -lboinc $(MAKEFILE_LDFLAGS) \
	$(STDCPPTC)

Square.o: Square.cpp
	$(CXX) $(CXXFLAGS) -c Square.cpp
	
RakeSearch.o: RakeSearch.cpp
	$(CXX) $(CXXFLAGS) -c RakeSearch.cpp
	
main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp

