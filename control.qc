float MIN_ALPHA = 0.0001;

float CTRL_SPAWNFLAG_SOLIDITY = 1;

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
            error("Cannot control solidity of class:");
            error(ent.classname);
        }
    }
};

void() ControlVisUse = {
    BaseControl(ControlVisProc);
};

void() control_vis = {
    self.use = ControlVisUse;
};
