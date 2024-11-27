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

$(TARGET): $(DLL_TARGET) $(OBJ_FILES)
	$(CC) $(OBJ_FILES) -o $@ $(CLFAGS) $(wildcard $(LINK_DIR)/*.a)

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CLFAGS) -c $< -o $@

#For compiling dynamic code into linked libraries
$(BIN)/%.dll: $(DLL)/%.c
	$(CC) -shared -o $@ $< "-Wl,--out-implib,$(LINK_DIR)/lib$*.a"