float FXMA_SPAWNFLAG_STATIC = 1;

string FXMA_EMPTY_MODEL = "progs/s_light.mdl";

void() FxModelInit = {
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;

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
        state = (self.model == self.map);
    }

    if (state) {
        setmodel(self, self.wad);
    } else {
        setmodel(self, self.map);
    }
};

void() fx_model_toggle = {
    FxModelInit();

    if (self.spawnflags & FXMA_SPAWNFLAG_STATIC) {
        makestatic(self);
        return;
    }

    // primary model
    self.map = self.model;

    if ((!self.map) || self.map == "") {
        self.map = FXMA_EMPTY_MODEL;
        precache_model(self.map);
        setmodel(self, self.map);
    }

    if (self.wad && self.wad != "") {
        // secondary model
        precache_model(self.wad);
    } else {
        self.wad = FXMA_EMPTY_MODEL;
        precache_model(self.wad);
    }

    self.use = FxModelToggleUse;
};
