# taken largely from: 
# https://github.com/gbdev/gb-asm-tutorial/blob/master/galactic-armada/Makefile
# and
# https://github.com/bitnenfer/flappy-boy-asm/blob/master/Makefile

PROJECT_NAME := cetus
SRC_DIR   := src
BUILD_DIR := build
OBJ_DIR   := $(BUILD_DIR)/obj
BIN := $(BUILD_DIR)/$(PROJECT_NAME).gb

# tools
ASM  := rgbasm
LINK := rgblink
FIX  := rgbfix

# tool flags
ASM_FLAGS := -L
FIX_FLAGS := -v -p 0xFF

# from https://stackoverflow.com/a/18258352/1221106
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
SRC_FILES := $(call rwildcard, $(SRC_DIR), *.asm)
# add obj prefix, remove src, change extension
OBJ_FILES := $(addprefix $(OBJ_DIR)/, $(SRC_FILES:$(SRC_DIR)/%.asm=%.o))
OBJ_DIRS  := $(sort $(addprefix $(OBJ_DIR)/, $(dir $(SRC_FILES:$(SRC_DIR)/%.asm=%.o))))

all: $(BIN)

$(BIN): $(OBJ_FILES) 
	$(LINK) -m $(BUILD_DIR)/$(PROJECT_NAME).map -n $(BUILD_DIR)/$(PROJECT_NAME).sym -o $@ $^
	$(FIX) $(FIX_FLAGS) $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm | $(OBJ_DIRS)
	$(ASM) $(ASM_FLAGS) -o $@ $<

$(OBJ_DIRS): 
	mkdir -p $@

clean:
	rm -rfv $(BUILD_DIR)

.PHONY: all clean
