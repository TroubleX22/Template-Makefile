# Barebones makefile

# Compiler stuff
CC = gcc
CPPC = g++
FINAL_COMP := $(CPPC)

FLAGS := -Wall -lstdc++
LIBRARIES := 

SHAR_FLAGS := -fPIC -shared

INCLUDES = includes

# Binary Name
binName = program.bin

# Directories
SRC = src
OBJ = obj
BIN = bin

SHAR_SRC_DIR := shared_src

# Source and object files
SRC_FILES := $(wildcard $(SRC)/*.c)

CPP_SRC_FILES := $(wildcard $(SRC)/*.cpp)

OBJ_FILES := $(strip $(patsubst $(SRC)/%.c,$(OBJ)/%.o,$(SRC_FILES)) $(patsubst $(SRC)/%.cpp,$(OBJ)/%.opp, $(CPP_SRC_FILES)))
# Note: .opp is a file extension used to identify C++ files differently from C object files for propper linking

# For already compiled libraries
LIB_DIR = libraries
LIBS := $(wildcard $(LIB_DIR)/*/)

LIB_SHAR_FILES := $(foreach folder,$(LIBS),$(wildcard $(folder)*.so))
LIB_OBJ_FILES := $(foreach folder,$(LIBS),$(wildcard $(folder)*.o)) $(foreach folder,$(LIBS),$(wildcard $(file)*.opp))
RELOC_LIB_OBJ_FILES := $(foreach folder,$(LIBS),$(patsubst $(folder)/%.o,$(OBJ)/%.o,$(wildcard $(folder)/*.o))) $(foreach folder,$(LIBS),$(patsubst $(folder)/%.opp,$(OBJ)/%.opp,$(wildcard $(file)/*.opp)))

LIB_LINK := $(foreach folder, $(LIBS), \
	$(foreach file, $(wildcard $(folder)*.so), \
	$(patsubst $(folder)lib%.so,  -l%, $(file)) \
	) \
)

# Shared Object source files
SHAR_SRC := $(wildcard $(SHAR_SRC_DIR)/*.c)

SHAR_CPP_SRC := $(wildcard $(SHAR_SRC_DIR)/*.cpp)

SHAR_BIN_LINK := $(strip $(patsubst $(SHAR_SRC_DIR)/%.c,-l%,$(SHAR_SRC)) $(patsubst $(SHAR_SRC_DIR)/%.cpp,-l%, $(SHAR_CPP_SRC)))

SHAR_BIN := $(strip $(patsubst $(SHAR_SRC_DIR)/%.c,$(BIN)/%.so,$(SHAR_SRC)) $(patsubst $(SHAR_SRC_DIR)/%.cpp,$(BIN)/%.sopp,$(SHAR_CPP_SRC)))



ifeq ($(strip $(SHAR_CPP_SRC) $(CPP_SRC_FILES)),)
FINAL_COMP = $(CC)
endif




# The first rule to compile everything
start: $(SHAR_BIN) $(OBJ_FILES)
	@echo ---Compiling final Binary---
	
# Coppy stuff
	@$(foreach folder,$(LIBS), $(foreach file, $(wildcard $(folder)*.o), cp $(file) $(patsubst $(folder)%.o,$(OBJ)/%.o,$(file));))
	@$(foreach folder,$(LIBS), $(foreach file, $(wildcard $(folder)*.opp), cp $(file) $(patsubst $(folder)%.opp,$(OBJ)/%.opp,$(file));))
	@$(foreach folder,$(LIBS), $(foreach file, $(wildcard $(folder)*.so), cp $(file) $(patsubst $(folder)%.so,$(BIN)/%.so,$(file));))

	@$(FINAL_COMP) $(filter $(OBJ)/%, $^) $(RELOC_LIB_OBJ_FILES) -o $(BIN)/$(binName) -L$(BIN)/ $(SHAR_BIN_LINK) $(LIB_LINK)


# Compile normal binaries
$(OBJ)/%.o: $(SRC)/%.c
	@echo ---Compiling $^ as object file---
	@$(CC) -I$(INCLUDES) -I$(SHAR_SRC_DIR) $(FLAGS) $(LIBRARIES) -c $^ -o $@

$(OBJ)/%.opp: $(SRC)/%.cpp
	@echo ---Compiling $^ as object file---
	@$(CPPC) -I$(INCLUDES) -I$(SHAR_SRC_DIR) $(FLAGS) $(LIBRARIES) -c $^ -o $@

# Compile Shared Objects
# Inspired by ChatGPT
$(BIN)/%.so: $(SHAR_SRC_DIR)/%.c
	@echo ---Compileing $^ as shared object file---
	@$(CC) -I$(INCLUDES) -I$(SRC) $(SHAR_FLAGS) $(FLAGS) $(LIBRARIES) $^ -o $(patsubst $(BIN)/%.so,$(BIN)/lib%.so,$@)

$(BIN)/%.sopp: $(SHAR_SRC_DIR)/%.cpp
	@echo ---Compileing $^ as shared object file---
	@$(CPPC) -I$(INCLUDES) -I$(SRC) $(SHAR_FLAGS) $(FLAGS) $(LIBRARIES) $^ -o $(patsubst $(BIN)/%.sopp,$(BIN)/lib%.so,$@)

clean:
	@echo ---Cleaning---
	@rm ./obj/*.o -rf
	@rm ./obj/*.opp -rf
	@rm ./bin/* -rf

# Create the standard directories
init:
	@echo ---Creating standard directories---
	
	@mkdir -p $(SRC)
	@mkdir -p $(OBJ)
	@mkdir -p $(BIN)
	
	@mkdir -p $(SHAR_SRC_DIR)
	
	@mkdir -p $(INCLUDES)

	@mkdir -p $(LIB_DIR)

