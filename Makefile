# General
CC			= cl65
LD			= cl65
RM			= rm -rf
RMDIR		= rmdir
INSTALL		= install
DEBUG		= 

## CHANGE THIS ##
TARGET		= test.nes
SRCDIR		= src
OBJDIR		= obj
BINDIR		= bin
## CHANGE THIS ##

# CFLAGS, LDFLAGS, CPPFLAGS, PREFIX can be overriden on CLI
CFLAGS		:= $(DEBUG) -c 
CPPFLAGS	:=
LDFLAGS		:= -t nes
PREFIX		:= /usr/local
TARGET_ARCH :=


# Compiler Flags
ALL_CFLAGS		:= $(CFLAGS)
# Preprocessor Flags
ALL_CPPFLAGS	:= $(CPPFLAGS)

# Linker Flags
ALL_LDFLAGS		:= $(LDFLAGS)
ALL_LDLIBS		:= 


# Source, Binaries, Dependencies
SRC			:= $(shell find $(SRCDIR) -type f -name '*.c')
OBJ			:= $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(SRC:.c=.o))
DEP			:= $(OBJ:.o=.d)
BIN			:= $(BINDIR)/$(TARGET)
-include $(DEP)


# Verbosity Control, ala automake
V 			= 0

# Verbosity for CC
REAL_CC 	:= $(CC)
CC_0 		= @echo "CC $<"; $(REAL_CC)
CC_1 		= $(REAL_CC)
CC 			= $(CC_$(V))

# Verbosity for LD
REAL_LD 	:= $(LD)
LD_0 		= @echo "LD $@"; $(REAL_LD)
LD_1 		= $(REAL_LD)
LD 			= $(LD_$(V))

# Verbosity for RM
REAL_RM 	:= $(RM)
RM_0 		= @echo "Cleaning..."; $(REAL_RM)
RM_1 		= $(REAL_RM)
RM 			= $(RM_$(V))

# Verbosity for RMDIR
REAL_RMDIR 	:= $(RMDIR)
RMDIR_0 	= @$(REAL_RMDIR)
RMDIR_1 	= $(REAL_RMDIR)
RMDIR 		= $(RMDIR_$(V))



# Build Rules
.PHONY: clean
.DEFAULT_GOAL := all

all: setup $(BIN)
setup: dir
remake: clean all

dir:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(BINDIR)


$(BIN): $(OBJ)
	$(LD) $(ALL_LDFLAGS) $^ $(ALL_LDLIBS) -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(ALL_CFLAGS) $(ALL_CPPFLAGS)  -o $@ $< 


install: $(BIN)
	$(INSTALL) -d $(PREFIX)/bin
	$(INSTALL) $(BIN) $(PREFIX)/bin

clean:
	$(RM) $(OBJ) $(DEP) $(BIN)
	$(RMDIR) $(OBJDIR) $(BINDIR) 2> /dev/null; true

