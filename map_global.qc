// Mask for runes and "fake" rune
const float SPAWN2_MASK = 0x0000001F;
const float SPAWN2_FLAG = 0x00000010;

// multiply/divide to shift in/out the map global
static const float MAP_GLOBAL_SHIFT = SPAWN2_MASK+1;

// Mask for inter-map global
static const float MAP_GLOBAL_MASK = 0x00FFFFFF - SPAWN2_MASK;

static const float MAP_GLOBAL_MAX = floor(MAP_GLOBAL_MASK / MAP_GLOBAL_SHIFT);
static const float MAP_GLOBAL_MIN = -MAP_GLOBAL_MAX;

void(float x) StoreMapGlobal = {
    float global_bits = x * MAP_GLOBAL_SHIFT;
    if (x < 0) {
        global_bits = (global_bits - 1) & ~SPAWN2_MASK;
    }
    float rune_bits = serverflags & SPAWN2_MASK;
    serverflags = global_bits | rune_bits;
};

float() LoadMapGlobal = {
    float bits = (serverflags & MAP_GLOBAL_MASK) / MAP_GLOBAL_SHIFT;
    if (serverflags < 0) {
        return MAP_GLOBAL_MIN + bits;
    } else {
        return bits;
    }
};

