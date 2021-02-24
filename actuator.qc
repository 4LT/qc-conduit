float ACT_SPAWNFLAG_SOLID = 1;

float ACT_STATE_STOPPED = 0;
float ACT_STATE_FORWARD = 1;
float ACT_STATE_REVERSE = 2;

void() ActuatorStop = {
    self.state = ACT_STATE_STOPPED;
    self.velocity = '0 0 0';
    self.cnt = self.ltime;

    sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
};

void() ActuatorMove = {
    if (self.height < self.io_received) {
        self.state = ACT_STATE_FORWARD;
    } else {
        self.state = ACT_STATE_REVERSE;
    }

    vector next_dest = self.pos2 * self.io_received + self.pos1;
    SUB_CalcMove(next_dest, self.speed, ActuatorStop);

    sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
};

void() CalcScalarPos = {
    self.height = vlen(self.origin - self.pos1) / self.t_length;
};

void() ActuatorRecalcAndMove = {
    CalcScalarPos();
    ActuatorMove();
};

void() ActuatorUse = {
    CalcScalarPos();
    float behind = self.height < self.io_received;
    float nextmove = self.cnt + self.wait;

    if (self.state == ACT_STATE_STOPPED) {
        // Start moving eventually
        if (nextmove <= self.ltime) {
            ActuatorMove();
        } else {
            self.think = ActuatorRecalcAndMove;
            self.nextthink = nextmove;
        }
    } else if ((self.state == ACT_STATE_FORWARD && behind)
            || (self.state == ACT_STATE_REVERSE && (!behind))) {
        // Keep moving
        // Call again to update destination
        ActuatorMove();
    } else {
        // Stop & reverse direction
        ActuatorStop();
        self.think = ActuatorRecalcAndMove;
        self.nextthink = self.cnt + self.wait;
    }
};

void() ActuatorInit = {
    entity dest_ent = find(world, targetname, self.target);
    if (!dest_ent) {
        error("func_actuator requires a target!");
    }
    
    // displacement from start to target dest
    self.pos2 = dest_ent.origin - self.pos1;

    // distance from position start to target dest
    self.t_length = vlen(self.pos2);

    self.use = ActuatorUse;
};

void() MoverInitSounds = {
    string stop_snd;
    string move_snd;
    
    switch(self.sounds) {
        case 1: // DOOR Stone
            stop_snd = "doors/drclos4.wav";
            move_snd = "doors/doormv1.wav";
            break;

        case 2: // DOOR Machine
            stop_snd = "doors/hydro2.wav";
            move_snd = "doors/hydro1.wav";
            break;

        case 3: // DOOR Chain
            stop_snd = "doors/stndr2.wav";
            move_snd = "doors/stndr1.wav";
            break;

        case 4: // DOOR Metal
            stop_snd = "doors/ddoor2.wav";
            move_snd = "doors/ddoor1.wav";
            break;

        case 5: // DOOR SEC Medieval
            stop_snd = "doors/latch2.wav";
            move_snd = "doors/winch2.wav";
            break;

        case 6: // DOOR SEC Metal
            stop_snd = "doors/airdoor2.wav";
            move_snd = "doors/airdoor1.wav";
            break;

        case 7: // DOOR SEC Base
            stop_snd = "doors/basesec2.wav";
            move_snd = "doors/basesec1.wav";
            break;

        case 8: // PLAT Base
            stop_snd = "plats/plat2.wav";
            move_snd = "plats/plat1.wav";
            break;

        case 9: // PLAT Chain
            stop_snd = "plats/medplat2.wav";
            move_snd = "plats/medplat1.wav";
            break;

        case 10: // TRAIN Ratchet
            stop_snd = "plats/train2.wav";
            move_snd = "plats/train1.wav";
            break;

        default: // Silent
            stop_snd = "misc/null.wav";
            move_snd = "misc/null.wav";
    }

    if ((!self.noise1) || self.noise1 == "") {
        self.noise1 = stop_snd;
    }

    if ((!self.noise2) || self.noise2 == "") {
        self.noise2 = move_snd;
    }

    precache_sound(self.noise1);
    precache_sound(self.noise2);
};

void() func_actuator = {
    self.movetype = MOVETYPE_PUSH;
    self.state = ACT_STATE_STOPPED;

    // time since stopping
    self.cnt = -self.wait;

    // current position as scalar
    self.height = 0;

    if (self.speed <= 0) {
        self.speed = 40;
    }

    if (self.spawnflags & ACT_SPAWNFLAG_SOLID) {
        self.solid = SOLID_BSP;
    } else {
        self.solid = SOLID_NOT;
    }

    // starting point
    self.pos1 = self.origin;

    setorigin(self, self.origin);
    setmodel(self, self.model);

    self.think = ActuatorInit;
    self.nextthink = 0.01;

    MoverInitSounds();
};
