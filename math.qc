// General-purpose math functions

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
