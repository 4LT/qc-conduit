float ACT_SPAWNFLAG_SOLID = 1;

float ACT_STATE_STOPPED = 0;
float ACT_STATE_FORWARD = 1;
float ACT_STATE_REVERSE = 2;

void() ActuatorStop = {
    self.state = ACT_STATE_STOPPED;
    self.velocity = '0 0 0';
    self.nextthink = -1;
    self.cnt = time;
};

void() ActuatorMove = {
    if (self.height < self.io_received) {
        self.state = ACT_STATE_FORWARD;
    } else {
        self.state = ACT_STATE_REVERSE;
    }

    self.height = self.io_received;

    vector next_dest = self.pos2 * self.io_received + self.pos1;
    SUB_CalcMove(next_dest, self.speed, ActuatorStop);
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
        if (nextmove <= time) {
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
        ActuatorUse();
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
};

void() func_actuator = {
    self.use = ActuatorUse;
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
    self.nextthink = time + 0.0001;
};
