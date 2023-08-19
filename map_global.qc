// Mask for runes and "fake" rune
const float SPAWN2_MASK = 0x0000001F;
const float SPAWN2_FLAG = 0x00000010;

// multiply/divide to shift in/out the map global
const float MAP_GLOBAL_SHIFT = SPAWN2_MASK+1;

// Mask for inter-map global
const float MAP_GLOBAL_MASK_UNSIGNED = 0x00FFFFFF - SPAWN2_MASK;

const float MAP_GLOBAL_MAX = MAP_GLOBAL_MASK_UNSIGNED / MAP_GLOBAL_SHIFT;
const float MAP_GLOBAL_MIN = -MAP_GLOBAL_MAX;

void(float x) StoreMapGlobal = {
    float sign = x < 0 ? -1 : 1;
    float global_bits = (x * sign * MAP_GLOBAL_SHIFT)
        & MAP_GLOBAL_MASK_UNSIGNED;
    float rune_bits = (serverflags * sign) & SPAWN2_MASK;
    serverflags = (global_bits | rune_bits) * sign;
};

float() LoadMapGlobal = {
    float bits = (serverflags & MAP_GLOBAL_MASK_UNSIGNED) / MAP_GLOBAL_SHIFT;
    if (serverflags < 0) {
        return MAP_GLOBAL_MIN - -bits;
    } else {
        return bits;
    }
};

