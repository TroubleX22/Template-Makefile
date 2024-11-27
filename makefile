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

all: $(TARGET)

clean:
	@echo ---Cleaning up orphaned object files---
	@for obj in $(OBJ_FILES); do \
		if [ ! -f "$(SRC)/$$(basename $$obj .o).c" ]; then \
			echo "Deleting orphaned object file $$obj"; \
			rm -f $$obj; \
		fi \
	done
	@echo ---Cleaning up orphaned DLL files---
	@for dll in $(DLL_TARGET); do \
		if [ ! -f "$(DLL)/$$(basename $$dll .dll).c" ]; then \
			echo "Deleting orphaned DLL file $$dll"; \
			rm -f $$dll; \
		fi \
	done
	@echo ---Cleaning up target executable---
	@rm -f $(TARGET)

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