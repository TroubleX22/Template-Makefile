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
LINKARCH := $(wildcard $(LINK_DIR)/*.a)

DLL_TARGET := $(DLL_FILES:$(DLL)/%.c=$(BIN)/%.dll)

all: $(TARGET) clean_excess

$(TARGET): $(DLL_TARGET) $(OBJ_FILES)
	@echo ---Compiling $(OBJ_FILES)---
	@$(CC) $(OBJ_FILES) -o $@ $(CLFAGS) $(wildcard $(LINK_DIR)/*.a)

#For deleting changed object files and compiling new ones
$(OBJ)/%.o: $(SRC)/%.c
	@echo ---Compiling $<---
	@$(CC) $(CLFAGS) -c $< -o $@

#For deleting the changed .dll's and compiling dynamic code into linked libraries
$(BIN)/%.dll: $(DLL)/%.c
	@echo ---Compiling $<---
	@$(CC) -shared -o $@ $< "-Wl,--out-implib,$(LINK_DIR)/lib$*.a"

clean_excess:
	@echo ---Deleing excess .dll files---

	$(foreach wrd,$(wildcard $(BIN)/*.dll), \
	$(shell \
		if not exist $(patsubst $(BIN)/%.dll,$(DLL)/%.c,$(wrd)) \
			( \
				del $(subst /,\,$(wrd)) \
			) \
		) \
	)
	
	$(foreach wrd,$(wildcard $(LINK_DIR)/lib*.a), echo \
	$(shell \
		if not exist $(patsubst $(LINK_DIR)/lib*.a,$(DLL)/%.c,$(wrd)) \
			( \
				echo $(subst /,\,$(wrd)) \
			) \
		) \
	)

clean:
	@echo ---Cleaning all objects and binaries---
	@if NOT "$(wildcard $(OBJ)/*.o)" == "" ( del $(subst /,\,$(wildcard $(OBJ)/*.o)) )

	@if NOT "$(wildcard $(BIN)/*.exe)" == "" (@del $(subst /,\,$(wildcard $(BIN)/*.exe)))
	
	@if NOT "$(wildcard $(BIN)/*.dll)" == "" (@del  $(subst /,\,$(wildcard $(BIN)/*.dll)))