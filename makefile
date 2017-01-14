# ����Ҫ��	Windows
#		GCC
#		GNU Binutils 2.24���� (����2.25.0�������)
#		GNU Make
#
# ����ƽ̨��	Windows 7 SP1
#		MinGW-W64 32λ�׼� (i686-6.2.0-release-win32-sjlj-rt_v5-rev1)
#
# ����ƽ̨��	����Windowsϵͳ
#

CC:=		gcc
CXX:=		g++
RC:=		windres
LIB:=		lib
MIDL:=		midl
RM:=		rm

OUTDIR:=	Release/
CFLAGS:=	-O3 -I.
CXXFLAGS:=	-O3 -I.
RCFLAGS:=	
LINKFLAGS:=	-s -static -Wl,--subsystem,console:4.0 -Wl,--image-base,0x62e40000 -Wl,--insert-timestamp -Wl,--enable-stdcall-fixup
IMPLIB:=	bass.lib mss32.lib
IMPOBJ:=	

CSRC:=		
CSRCSSE:=	
CXXSRC:=	swrap.cpp
CXXSRC+=	soundwrapper.cpp
CXXSRCSSE:=	

COBJ:=		$(CSRC:%.c=%.o)
COBJSSE:=	$(CSRCSSE:%.c=%.o)
CXXOBJ:=	$(CXXSRC:%.cpp=%.o)
CXXOBJSSE:=	$(CXXSRCSSE:%.cpp=%.o)

RES:=		$(OUTDIR)swrap.res
LINKOBJ:=	$(COBJ) $(COBJSSE) $(CXXOBJ) $(CXXOBJSSE) $(RES)
DEFFILE:=	swrap.def
#OUTLIB:=	$(OUTDIR)swrap.lib
BIN:=		$(OUTDIR)swrap.dll
DEBUGBIN:=	$(OUTDIR)swrapd.dll

.PHONY: all debug clean cleanobj

all:	$(BIN)

debug:	$(DEBUGBIN)
debug:	CFLAGS += -DDEBUG
debug:	CXXFLAGS += -DDEBUG
debug:	RCFLAGS += -DDEBUG -D_DEBUG

clean:
	$(RM) $(BIN) $(DEBUGBIN) $(LINKOBJ) *.o

cleanobj:
	$(RM) $(LINKOBJ) *.o

$(BIN): $(LINKOBJ)
	$(CC) -shared -o $(BIN) $(LINKOBJ) $(IMPOBJ) $(IMPLIB) $(DEFFILE) $(LINKFLAGS)
#	$(LIB) /nologo /def:$(DEFFILE) $(LINKOBJ) $(IMPOBJ) $(IMPLIB) /out:$(OUTLIB)

$(DEBUGBIN): $(LINKOBJ)
	$(CC) -shared -o $(DEBUGBIN) $(LINKOBJ) $(IMPOBJ) $(IMPLIB) $(DEFFILE) $(LINKFLAGS)

$(RES): swrap.rc
	$(RC) $(RCFLAGS) $< -o $(RES) -O coff

$(COBJ): $(CSRC)

$(COBJSSE): $(CSRCSSE)
$(COBJSSE): CFLAGS += -msse2

$(CXXOBJ): $(CXXSRC)

$(CXXOBJSSE): $(CXXSRCSSE)
$(CXXOBJSSE): CXXFLAGS += -msse2

%.o:%.c
	$(CC) -o $@ $(CFLAGS) -c $<

%.o:%.cpp
	$(CXX) -o $@ $(CXXFLAGS) -c $<


