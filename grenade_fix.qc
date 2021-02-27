void(vector normal) GrenadeForceBounce;
vector(vector incident, vector normal) reflect;

void() GrenadeHandlePhysics = {
    float dot, horiz_mag;
    vector horiz_vel, horiz_dir;

    if (self.velocity_z > 0) {
        return;
    } 

    if (self.velocity == '0 0 0') {
        return;
    }

    traceline(
            self.origin,
            self.velocity,
            1,
            self);

    if (trace_ent != other || trace_plane_normal_z <= 0) {
        return;
    }

    horiz_vel = self.velocity;
    horiz_vel_z = 0;
    horiz_mag = vlen(horiz_vel);

    // if moving straight down
    if (horiz_mag == 0) {
        // probably okay?
        return;
    } else {
        horiz_dir = horiz_vel/horiz_mag;
        dot = horiz_dir * trace_plane_normal;

        if (dot > 0) {
            GrenadeForceBounce(trace_plane_normal);
        } 
    }
};

void() GrenadeForceBounceThink = {
    self.think = self.think1;
    self.nextthink = self.pausetime;
    self.velocity = self.pos1;
    self.avelocity = '300 300 300';
    self.flags = self.flags & (-1 - FL_ONGROUND);
};

void(vector normal) GrenadeForceBounce = {
    // velocity will be zeroed, so cache it as pos1
    self.pos1 = reflect(-self.velocity, normal);

    // cache existing think
    self.think1 = self.think;
    self.pausetime = self.nextthink;

    // FL_ONGROUND will get set, so clear it next frame
    self.think = GrenadeForceBounceThink;
    self.nextthink = time;
};
