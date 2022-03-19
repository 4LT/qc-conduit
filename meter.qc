void() MoverInitSounds; // borrow from slider.qc

void() MeterStop = {
    self.io_send = self.io_received;
    SUB_UseTargets();
    sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
};

void() MeterUse = {
    vector delta_angles = (self.mangle - self.pos1) * self.io_received;
    vector dest_angles = self.pos1 + delta_angles;
    SUB_CalcAngleMove(dest_angles, self.speed, MeterStop);
    sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
};

void() func_meter = {
    self.movetype = MOVETYPE_NOCLIP;

    if (self.speed <= 0) {
        self.speed = 45;
    }

    // Initial orientation
    self.pos1 = self.angles;

    // I don't trust collisions with rotating brushes (/shrug)
    self.solid = SOLID_NOT;

    setorigin(self, self.origin);
    setmodel(self, self.model);
    
    MoverInitSounds();
    precache_sound("misc/null.wav");

    self.use = MeterUse;
};
