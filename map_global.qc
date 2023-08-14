// Mask for runes and "fake" rune
const float SPAWN2_MASK = 0x0000001F;

// multiply/divide to shift in/out the map global
const float MAP_GLOBAL_SHIFT = SPAWN2_MASK+1;

// Mask for sign inter-map global
const float MAP_GLOBAL_MASK_UNSIGNED = 0x00FFFFFF & ~SPAWN2_MASK;

void(float x) StoreMapGlobal = {
    float x_unsigned = x * MAP_GLOBAL_SHIFT * (x < 0 ? -1 : 1);
    serverflags = (MAP_GLOBAL_MASK_UNSIGNED & x_unsigned)
        | (SPAWN2_MASK & serverflags);

    if (x < 0) {
        serverflags*= -1;
    }
};

float() LoadMapGlobal = {
    float flags;
    float sign = serverflags < 0;

    if (sign) {
        flags = -serverflags;
    } else {
        flags = serverflags;
    }

    return (MAP_GLOBAL_MASK_UNSIGNED & flags)
        * (sign ? -1 : 1)
        / MAP_GLOBAL_SHIFT;
};
