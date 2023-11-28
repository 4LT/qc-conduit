// General-purpose math functions

static const float MIN_ANG = -180;
static const float MAX_ANG = 180;
const float NAN = 0/0;
const float INF = 1/0;

float(float x) isnan = {
    return x != x;
};

float(float x) isfinite = {
    return x == x && x != INF && x != -INF;
};

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

/*
 * Find the sqrt of an integer by leveraging vlen in O(log x) instructions
 */
float(float x) isqrt {
    float quot, rem, rt;

    quot = floor(x/2);
    rem = x - quot * 2;

    if (quot > 1) {
        rt = isqrt(quot);
        return vlen([rt, rt, rem]);
    } else {
        return vlen([quot, quot, rem]);
    }
};

/*
 * Approximate the sqrt of a number in O(log x) instructions
 */
float(float x) sqrt {
    // boost precision for low values while avoiding saturation on high values
    if (x < 256) {
        return isqrt(rint(x * 256)) / 16;
    } else if (x <= 0xFFFFFF) { // check for EXCEEDINGLY large values
        return isqrt(rint(x));
    } else {
        return isqrt(x);
    }
};

/* Find the roots to a quadratic equation
 * a - Quadratic coefficient
 * b - Linear coefficient
 * c - Constant coefficient
 *
 * Roots are returned as _x and _y of vector, or 1 is returned for _z of vector
 */
vector(float a, float b, float c) quadratic {
    float det, det_sqrt;
    vector ret_vec;

    det = b*b - 4 * a * c;
    if (det < 0) {
        return [NAN, NAN, 1];
    }

    ret_vec = '0 0 0';
    det_sqrt = sqrt(det);
    ret_vec_x = (-b + det_sqrt) / 2 / a;
    ret_vec_y = (-b - det_sqrt) / 2 / a;

    return ret_vec;
};
