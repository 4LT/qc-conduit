// General-purpose math functions

float MIN_ANG = -180;
float MAX_ANG = 180;

float math_err;

float(float a, float b) max = {
    if (a > b) {
        return a;
    } else {
        return b;
    }
};

float(float a, float b) min = {
    if (a < b) {
        return a;
    } else {
        return b;
    }
};

float(float a, float b) mod = {
    return a - floor(a / b) * b;
};

float(float a, float b) safe_div = {
    math_err = 0;
    if (b == 0) {
        math_err = 1;
        return 0;
    } else {
        return a/b;
    }
};

float(float a, float b) safe_mod = {
    math_err = 0;
    if (b == 0) {
        math_err = 1;
        return 0;
    } else {
        return mod(a, b);
    }
};

// reflect incident over normal, dampening it against the normal
vector(vector incident, vector normal, float dampening) reflect = {
    // project incident along normal
    float d = incident * normal;
    vector p = d * normal;

    vector i2p = p - incident;
    vector reflected = incident + 2 * i2p;

    return reflected - d * dampening * normal;
};

float(float in, float min, float max) wrap = {
    return mod(in - min, max - min) + min;
};

vector(vector in) normalize_angles = {
    vector out;
    float flip = 0;
    out_x = wrap(in_x, MIN_ANG, MAX_ANG);
    
    if (out_x < -90 || out_x > 90) {
        if (out_x < -90) {
            out_x = -180 - out_x;
        } else {
            out_x = 180 - out_x;
        }
        
        flip = 180;
    }

    out_y = wrap(in_y + flip, MIN_ANG, MAX_ANG);
    out_z = wrap(in_z + flip, MIN_ANG, MAX_ANG);

    return out;
};

vector(vector in) normalize_delta_angles = {
    vector out;
    out_x = wrap(in_x, MIN_ANG, MAX_ANG);
    out_y = wrap(in_y, MIN_ANG, MAX_ANG);
    out_z = wrap(in_z, MIN_ANG, MAX_ANG);
    return out;
};
