# taken largely from: 
# https://github.com/gbdev/gb-asm-tutorial/blob/master/galactic-armada/Makefile
# and
# https://github.com/bitnenfer/flappy-boy-asm/blob/master/Makefile

PROJECT_NAME := cetus
SRC_DIR   := src
TILES_DIR := $(SRC_DIR)/assets/tiles

BUILD_DIR := build
BUILD_GFX_DIR := $(BUILD_DIR)/gfx
BUILD_OBJ_DIR := $(BUILD_DIR)/obj
BIN := $(BUILD_DIR)/$(PROJECT_NAME).gb

# tools
ASM  := rgbasm
LINK := rgblink
FIX  := rgbfix
GFX  := rgbgfx

# tool flags
ASM_FLAGS := 
LINK_FLAGS := #-t # this makes the rom "tiny", such that all ROM is considered a single unextensible ROM0 bank. will remove when rom exceeds 64k
FIX_FLAGS := -v -p 0xFF -C --mbc-type MBC5

# from https://stackoverflow.com/a/18258352/1221106
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SRC_FILES := $(call rwildcard, $(SRC_DIR), *.asm)
# add obj prefix, remove src, change extension
OBJ_FILES := $(addprefix $(BUILD_OBJ_DIR)/, $(SRC_FILES:$(SRC_DIR)/%.asm=%.o))
BUILD_OBJ_DIRS := $(sort $(addprefix $(BUILD_OBJ_DIR)/, $(dir $(SRC_FILES:$(SRC_DIR)/%.asm=%.o))))

TILE_FILES := $(call rwildcard, $(TILES_DIR), *.png)
2BPP_FILES := $(addprefix $(BUILD_GFX_DIR)/, $(TILE_FILES:$(TILES_DIR)/%.png=%.2bpp))
BUILD_2BPP_DIRS := $(sort $(addprefix $(BUILD_GFX_DIR)/, $(dir $(TILE_FILES:$(TILES_DIR)/%.png=%.2bpp))))

all: $(2BPP_FILES) $(BIN) 

$(BIN): $(OBJ_FILES) 
	$(LINK) $(LINK_FLAGS) -m $(BUILD_DIR)/$(PROJECT_NAME).map -n $(BUILD_DIR)/$(PROJECT_NAME).sym -o $@ $^
	$(FIX) $(FIX_FLAGS) $@

$(BUILD_OBJ_DIR)/%.o: $(SRC_DIR)/%.asm | $(BUILD_OBJ_DIRS)
	$(ASM) $(ASM_FLAGS) -o $@ $<

$(BUILD_OBJ_DIRS):
	mkdir -p $@

$(BUILD_GFX_DIR)/%.2bpp: $(TILES_DIR)/%.png | $(BUILD_2BPP_DIRS)
	$(GFX) -o $@ $<

$(BUILD_2BPP_DIRS):
	mkdir -p $@

clean:
	rm -rfv $(BUILD_DIR)

.PHONY: all clean
