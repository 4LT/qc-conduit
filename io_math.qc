float IOM_SPAWNFLAG_REVERSE = 1;

float IOM_SPAWNFLAG_BOUND_U = 1;
float IOM_SPAWNFLAG_BOUND_L = 2;
float IOM_SPAWNFLAG_FIRE_CHANGE_ONLY = 4;
float IOM_SPAWNFLAG_FIRE_BOUNDS_ONLY = 8;

float IOM_OP_ADD = 0;
float IOM_OP_SUB = 1;
float IOM_OP_MUL = 2;
float IOM_OP_DIV = 3;
float IOM_OP_MOD = 4;
float IOM_OP_FLOOR = 5;
float IOM_OP_CEIL = 6;
float IOM_OP_MIN = 7;
float IOM_OP_MAX = 8;

float IOM_CMP_LT = 0;
float IOM_CMP_LTE = 1;
float IOM_CMP_GT = 2;
float IOM_CMP_GTE = 3;
float IOM_CMP_EQ = 4;
float IOM_CMP_NE = 5;

void() ApplyOp = {
    float reverse = self.spawnflags & IOM_SPAWNFLAG_REVERSE;
    math_err = 0;

    switch (self.style) {
        case IOM_OP_SUB:
            if (reverse) {
                self.io_send = self.io_arg2 - self.io_received;
            } else {
                self.io_send = self.io_received - self.io_arg2;
            }
            break;

        case IOM_OP_MUL:
            self.io_send = self.io_received * self.io_arg2;
            break;

        case IOM_OP_DIV:
            if (reverse) {
                self.io_send = safe_div(self.io_arg2, self.io_received);
            } else {
                self.io_send = safe_div(self.io_received, self.io_arg2);
            }
            break;

        case IOM_OP_MOD:
            if (reverse) {
                self.io_send = safe_mod(self.io_arg2, self.io_received);
            } else {
                self.io_send = safe_mod(self.io_received, self.io_arg2);
            }
            break;

        case IOM_OP_FLOOR:
            self.io_send = floor(self.io_received);
            break;

        case IOM_OP_CEIL:
            self.io_send = ceil(self.io_received);
            break;

        case IOM_OP_MIN:
            self.io_send = min(self.io_received, self.io_arg2);
            break;

        case IOM_OP_MAX:
            self.io_send = max(self.io_received, self.io_arg2);
            break;

        default: // IOM_OP_ADD
            self.io_send = self.io_received + self.io_arg2;
    }

    if (math_err) {
        bprint("math_op: illegal math operation\n");
    } else {
        SUB_UseTargets();
    }
};

void() math_op = {
    self.use = ApplyOp;
};

void() AddToAdder = {
    float old_count = self.io_send;
    float hit_bound = 0;
    float change_clearance = 1;
    float bound_clearance = 1;

    self.io_send+= self.io_received;

    if (self.spawnflags & IOM_SPAWNFLAG_BOUND_U) {
        self.io_send = min(self.io_send, self.waitmax);
        hit_bound = 1;
    } 

    if (self.spawnflags & IOM_SPAWNFLAG_BOUND_L) {
        self.io_send = max(self.io_send, self.waitmin);
        hit_bound = 1;
    }

    if (self.spawnflags & IOM_SPAWNFLAG_FIRE_BOUNDS_ONLY) {
        if (!hit_bound) {
            bound_clearance = 0;
        }
    }

    if (self.spawnflags & IOM_SPAWNFLAG_FIRE_CHANGE_ONLY) {
        if (self.io_send == old_count) {
            change_clearance = 0;
        }
    }

    if (bound_clearance && change_clearance) {
        SUB_UseTargets();
    }
};

void() math_adder = {
    self.use = AddToAdder;
};

void() math_var = {
    self.use = SUB_UseTargets;
};

void() CompareAndFire = {
    float result = 0;

    switch(self.style) {
        case IOM_CMP_LT:
            result = self.io_received < self.io_arg2;
            break;

        case IOM_CMP_LTE:
            result = self.io_received <= self.io_arg2;
            break;

        case IOM_CMP_GT:
            result = self.io_received > self.io_arg2;
            break;

        case IOM_CMP_GTE:
            result = self.io_received >= self.io_arg2;
            break;

        case IOM_CMP_NE:
            result = self.io_received != self.io_arg2;
            break;

        default: // IOM_CMP_EQ
            result = self.io_received == self.io_arg2;
    }

    if (result) {
        SUB_UseTargets();
    }
};

void() math_compare = {
    self.use = CompareAndFire;
};
