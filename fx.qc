float FXMA_SPAWNFLAG_STATIC = 1;

float FXMTR_SPAWNFLAG_TELEPORT = 1;

float FXMTR_STATE_SLIDING = 0;
float FXMTR_STATE_TURNING = 1;

string FXMA_EMPTY_MODEL = "progs/s_light.mdl";

void() MoverInitSounds;
vector(vector in) normalize_angles;
vector(vector in) normalize_delta_angles;

void() FxModelInit = {
    self.solid = SOLID_NOT;

    if (self.avelocity != '0 0 0') {
        self.movetype = MOVETYPE_NOCLIP;
    } else {
        self.movetype = MOVETYPE_NONE;
    }

    if (self.model && self.model != "") {
        precache_model(self.model);
        setmodel(self, self.model);
    }
};

void() FxModelToggleUse = {
    float state;

    if (self.io_received < 0) {
        state = 0;
    } else if (self.io_received > 0) {
        state = 1;
    } else {
        state = (self.model == self.wad);
    }

    if (state) {
        setmodel(self, self.map);
    } else {
        setmodel(self, self.wad);
    }
};

void() fx_model_toggle = {
    FxModelInit();

    if (self.spawnflags & FXMA_SPAWNFLAG_STATIC) {
        makestatic(self);
        return;
    }

    // primary model
    self.wad = self.model;

    if ((!self.wad) || self.wad == "") {
        self.wad = FXMA_EMPTY_MODEL;
        precache_model(self.wad);
        setmodel(self, self.wad);
    }

    if (self.map && self.wad != "") {
        // secondary model
        precache_model(self.map);
    } else {
        self.map = FXMA_EMPTY_MODEL;
        precache_model(self.map);
    }

    self.use = FxModelToggleUse;
};

void() FxModelTrainTranslate;
vector(entity corner) FxModelTrainGetDeltaAngles;

void() FxModelTrainStop = {
    self.use = FxModelTrainTranslate;
    sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
};

void() FxModelTrainTurn = {
    entity t;
    vector delta_angles;
    float turn_time;
    void() next_action;

    // Keep angles within reasonable limits, for precision's sake
    self.angles = normalize_angles(self.angles);

    // We just finished moving to target, so we know it *should* exist
    // (unless killtargeted, ofc)
    t = find(world, targetname, self.target);
    turn_time = fabs(t.wait);
    delta_angles = FxModelTrainGetDeltaAngles(t);

    if (delta_angles == '0 0 0') {
        if (t.wait == 0) {
            FxModelTrainTranslate();
        } else {
            FxModelTrainStop();

            if (t.wait > 0) {
                self.nextthink = time + turn_time;
                self.think = FxModelTrainTranslate;
            }
        }
    } else {
        if (turn_time == 0) {
            self.angles+= delta_angles;
            FxModelTrainStop();
        } else {
            if (t.wait > 0) {
                next_action = FxModelTrainTranslate;
            } else {
                next_action = FxModelTrainStop;
            }

            SUB_CalcAngleMove(
                    self.angles + delta_angles,
                    vlen(delta_angles) / turn_time,
                    next_action);
            sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
        }
    }

    self.target = t.target;
};

void() FxModelTrainTranslate = {
    entity t;

    // There may not be a next corner, so check that it exists
    if (self.target) {
        t = find(world, targetname, self.target);

        if (t) {
            // "Lock" train until it stops
            self.use = SUB_Null;

            SUB_CalcMove(t.origin, self.speed, FxModelTrainTurn);
            sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
            return;
        }
    }

    FxModelTrainStop();
};

vector(entity corner) FxModelTrainGetDeltaAngles = {
    entity next;
    vector turn_to;

    if (corner.target) {
        next = find(world, targetname, corner.target);

        if (next) {
            turn_to = vectoangles(next.origin - corner.origin) + self.mangle;
            turn_to = normalize_angles(turn_to);
            
            // minimize wobble going into vertical
            if (turn_to_x == 90 || turn_to_x == -90) {
                turn_to_y = self.angles_y;
            }

            turn_to_z = self.angles_z;

            // rotate MINIMUM distance
            return normalize_delta_angles(turn_to - self.angles);
        }
    }

    return '0 0 0';
};

void() FxModelTrainInit = {
    entity t;

    if (self.target) {
        t = find(world, targetname, self.target);

        if (t) {
            if (self.spawnflags & FXMTR_SPAWNFLAG_TELEPORT) {
                self.target = t.target;
                setorigin(self, t.origin);
                self.angles+= FxModelTrainGetDeltaAngles(t);
            } else {
                self.angles+= FxModelTrainGetDeltaAngles(self);
            }
        }
    }

    if (self.targetname == "" || !self.targetname) {
        FxModelTrainTranslate();
    }
};

void() fx_model_train = {
    FxModelInit();
    MoverInitSounds();

    // angular offset
    self.mangle = self.angles;
    
    if (self.noise3 && self.noise3 != "") {
        precache_sound(self.noise3);
    } else {
        self.noise3 = self.noise2;
    }

    self.movetype = MOVETYPE_NOCLIP;

    if (!self.speed) {
        self.speed = 100;
    } else {
        self.speed = fabs(self.speed);
    }

    self.nextthink = time + 0.01;
    self.think = FxModelTrainInit;
    self.use = FxModelTrainTranslate;
};
