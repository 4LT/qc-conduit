float MIN_ALPHA = 0.0001;

float CTRL_SPAWNFLAG_SOLIDITY = 1;
float CTRL_SPAWNFLAG_START_ON = 1;

void(void(entity ent, float arg) proc) BaseControl = {
    entity t = world;
    
    do {
        t = find(t, targetname, self.target);
        if (!t) {
            return;
        }
        proc(t, self.io_received);
    } while(1);
};

void(entity ent, float opacity) ControlVisProc = {
    ent.alpha = opacity;
    ent.alpha = max(ent.alpha, MIN_ALPHA);
    
    if (self.spawnflags & CTRL_SPAWNFLAG_SOLIDITY) {
        if (ent.classname == "func_wall") {
            if (ent.alpha > MIN_ALPHA) {
                ent.solid = SOLID_BSP;
            } else {
                ent.solid = SOLID_NOT;
            }
        } else if (ent.classname == "func_illusionary") {
            // Do nothing
        } else {
            dprint("Cannot control solidity of class: ");
            dprint(ent.classname);
            dprint("\n");
        }
    }
};

void() ControlVisUse = {
    BaseControl(ControlVisProc);
};

void() control_vis = {
    self.use = ControlVisUse;
};

void(entity ent, float send) ControlVarProc = {
    ent.io_send = send;
};

void(entity ent, float framenum) ControlFrameProc = {
    ent.frame = framenum;
};

void(entity ent, float arg2) ControlOperandProc = {
    ent.io_arg2 = arg2;
};

void() ControlVarUse = {
    BaseControl(ControlVarProc);
};

void() control_var = {
    self.use = ControlVarUse;
};

void() ControlOperandUse = {
    BaseControl(ControlOperandProc);
};

void() control_operand = {
    self.use = ControlOperandUse;
};

void() ControlFrameUse = {
    BaseControl(ControlFrameProc);
};

void() control_frame = {
    self.use = ControlFrameUse;
};

void() ControlAnimateUse = {
    if (self.io_received > 0) {
        self.nextthink = time + 0.1;
    } else if (self.io_received < 0) {
        self.nextthink = 0; 
    } else {
        self.nextthink = (!self.nextthink) * (time + 0.1);
    }
};

void() ControlAnimateThink = {
    float direction = (self.waitmax >= self.waitmin)*2 - 1;

    self.nextthink = self.wait + time;
    self.io_received = self.count;
    BaseControl(ControlFrameProc);

    self.count+= direction;

    if ((direction > 0 && self.count > self.waitmax) ||
            (direction < 0 && self.count < self.waitmax))
    {
        self.count = self.waitmin;
    }
};

void() control_animate = {
    self.count = self.waitmin;

    if (self.wait <= 0) {
        self.wait = 0.1;
    }

    if (self.spawnflags & CTRL_SPAWNFLAG_START_ON) {
        self.think = ControlAnimateThink;
        self.nextthink = 0.01;
    }
};
