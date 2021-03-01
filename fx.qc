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
