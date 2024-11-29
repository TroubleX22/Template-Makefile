SHELL = cmd

#Macros for compiler information
CC := gcc
INCLUDE := include
LIBRARIES := include/lib


CLFAGS := -I./$(INCLUDE) -L./$(LINK_DIR)

#Macros for directory and file information
BIN := bin
SRC := src
OBJ := obj

SRC_FILES := $(wildcard $(SRC)/*.c)
OBJ_FILES := $(SRC_FILES:$(SRC)/%.c=$(OBJ)/%.o)

TARGET := $(BIN)/a.exe

#Macros for dynamic link libraries
DLL := $(SRC)/dll
DLL_FILES := $(wildcard $(DLL)/*.c)

LINK_DIR := $(INCLUDE)/lib
LINKARCH := $(wildcard $(LINK_DIR)/*.lib)

DLL_TARGET := $(DLL_FILES:$(DLL)/%.c=$(BIN)/%.dll)

#Macros for external libraries

LIBS_DIR := libs
LIB_FILES := $(shell dir /s /b $(LIBS_DIR)\*.lib 2>nul)
LIB_HEADERS := $(foreach wrd,$(shell dir /s /b $(LIBS_DIR)\*.h 2>nul),-l(wrd))

#Main macros definition end

all: $(TARGET) clean_excess $(wildcard $(SRC)/*.c) $(wildcard $(DLL)/*.c)

$(TARGET): $(DLL_TARGET) $(OBJ_FILES)
	@echo ---Compiling $(OBJ_FILES)---
	@$(CC) $(OBJ_FILES) -o $@ $(CLFAGS) $(wildcard $(LINK_DIR)/*.lib) $(LIB_FILES)

#For deleting changed object files and compiling new ones
$(OBJ)/%.o: $(SRC)/%.c
	@echo ---Compiling $<---
	@$(CC) $(CLFAGS) -c $< -o $@

$(BIN)/%.dll: $(DLL)/%.c
	@echo ---Compiling $<---
	@$(CC) -shared -o $@ $< "-Wl,--out-implib,$(LINK_DIR)/lib$*.lib"

$(SRC)/%.c:
	echo WORKING!!
	$(foreach wrd,$(wildcard $(OBJ)/*.o), \
	$(shell \
		if not exist $(patsubst $(OBJ)/%.o,$(SRC)/%.c,$(wrd)) \
			( \
				del $(subst /,\,$(wrd)) \
			) \
		) \
	)

#For deleting the changed .dll's and compiling dynamic code into linked libraries
clean_excess: $(wildcard $(SRC)/*.c) $(wildcard $(DLL)/*.c)
	$(foreach wrd,$(wildcard $(BIN)/*.dll), \
	$(shell \
		if not exist $(patsubst $(BIN)/%.dll,$(DLL)/%.c,$(wrd)) \
			( \
				del $(subst /,\,$(wrd) && echo ---Deleting $(wrd)---) \
			) \
		) \
	)
	
	$(foreach wrd,$(wildcard $(LINK_DIR)/lib*.lib), \
	$(shell \
		if not exist $(patsubst $(LINK_DIR)/lib%.lib,$(DLL)/%.c,$(wrd)) \
			( \
				del $(subst /,\,$(wrd) && echo ---Deleting $(wrd)---) \
			) \
		) \
	)

	$(foreach wrd,$(wildcard $(OBJ)/*.o), \
	$(shell \
		if not exist $(patsubst $(OBJ)/%.o,$(SRC)/%.c,$(wrd)) \
			( \
				del $(subst /,\,$(wrd) && echo ---Deleting $(wrd)---) \
			) \
		) \
	)

clean:
	@echo ---Cleaning all objects and binaries---
	@if NOT "$(wildcard $(OBJ)/*.o)" == "" ( del $(subst /,\,$(wildcard $(OBJ)/*.o)) )

	@if NOT "$(wildcard $(BIN)/*.exe)" == "" (@del $(subst /,\,$(wildcard $(BIN)/*.exe)))
	
	@if NOT "$(wildcard $(BIN)/*.dll)" == "" (@del  $(subst /,\,$(wildcard $(BIN)/*.dll)))