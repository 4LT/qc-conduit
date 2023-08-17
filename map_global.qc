// Mask for runes and "fake" rune
const float SPAWN2_MASK = 0x0000001F;

// multiply/divide to shift in/out the map global
const float MAP_GLOBAL_SHIFT = SPAWN2_MASK+1;

// Mask for sign inter-map global
const float MAP_GLOBAL_MASK_UNSIGNED = 0x00FFFFFF & ~SPAWN2_MASK;

void(float x) StoreMapGlobal = {
    float sign = x < 0 ? -1 : 1;
    float global_bits = (x * sign * MAP_GLOBAL_SHIFT)
        & MAP_GLOBAL_MASK_UNSIGNED;
    float rune_bits = (serverflags * sign) & SPAWN2_MASK;
    serverflags = (global_bits | rune_bits) * sign;
};

float() LoadMapGlobal = {
    float sign = serverflags < 0 ? -1 : 1;
    float flags = serverflags * sign;
    return (MAP_GLOBAL_MASK_UNSIGNED & flags) * sign / MAP_GLOBAL_SHIFT;
};
