# Barebones makefile

# Compiler stuff
CC := gcc
FLAGS := -Wall
LIBRARIES := -lxcb

SHAR_SRC_FLAGS := -fPIC
SHAR_OBJ_FLAGS := -shared

INCLUDES := includes

# Binary Name
binName := program.bin

# Directories
SRC := src
OBJ := obj
BIN := bin

SHAR_SRC_DIR := shared_src
SHAR_OBJ_DIR := shared_obj

# Source and object files
SRC_FILES := $(wildcard $(SRC)/*.c)
OBJ_FILES := $(patsubst $(SRC)/%.c,$(OBJ)/%.o,$(SRC_FILES))

# Shared Object source files
SHAR_SRC := $(wildcard $(SHAR_SRC_DIR)/*.c)
SHAR_OBJ := $(patsubst $(SHAR_SRC_DIR)/%.c,$(SHAR_OBJ_DIR)/%.o,$(SHAR_SRC))
SHAR_BIN := $(patsubst $(SHAR_SRC_DIR)/%.c,-l%,$(SHAR_SRC))

start: $(SHAR_OBJ) $(OBJ_FILES)
	@echo ---Compiling final Binary---
	@$(CC) $(filter $(OBJ)/%, $^) -o $(BIN)/$(binName) -L$(BIN)/ $(SHAR_BIN)

# Compile normal binaries
$(OBJ)/%.o: $(SRC)/%.c
	@echo ---Compiling $^ as regular object file---
	@$(CC) -I$(INCLUDES) $(FLAGS) $(LIBRARIES) -c $^ -o $@

# Compile Shared Objects
# Inspired by ChatGPT
$(SHAR_OBJ_DIR)/%.o: $(SHAR_SRC_DIR)/%.c
	@echo ---Compileing $^ as shared object file---
	@$(CC) $(SHAR_SRC_FLAGS) -c $^ -o $@
	@$(CC) -I$(INCLUDES) $(SHAR_OBJ_FLAGS) $(FLAGS) $(LIBRARIES) $@ -o $(patsubst $(SHAR_OBJ_DIR)/%.o,$(BIN)/lib%.so,$@)

clean:
	@echo ---Cleaning---
	@rm ./obj/*.o -rf
	@rm ./shared_obj/*.o -rf
	@rm ./bin/* -rf

# Create the standard directories
innit:
	@echo ---Creating standard directories---
	
	@mkdir -p $(SRC)
	@mkdir -p $(OBJ)
	@mkdir -p $(BIN)
	
	@mkdir -p $(SHAR_SRC_DIR)
	@mkdir -p $(SHAR_OBJ_DIR)
	
	@mkdir -p $(INCLUDES)