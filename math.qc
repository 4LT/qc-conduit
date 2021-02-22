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

