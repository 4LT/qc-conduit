void(vector, entity) spawn_tdeath;
void() monster_boss;
void() FoundTarget;
float() droptofloor;

const float SPAWNER_FLAG_NO_TELEFLASH = 8;
const float SPAWNER_FLAG_ANGRY = 16;

void() SpawnerUse = {
    vector l_mins, l_maxs;
    entity spawner;
    entity monster = self.enemy;

    self.use = SUB_Null;

    if (monster.think != monster_boss) {
        monster.movetype = MOVETYPE_STEP;
        monster.solid = SOLID_SLIDEBOX;
    }

    l_mins = monster.mins;
    l_maxs = monster.maxs;
    setmodel(monster, self.model);
    setsize(monster, l_mins, l_maxs);

    monster.health = self.max_health;

    spawner = self;
    self = monster;

    if (!self.think) {
        dprint("Spawned monster has no think!\n");
    } else {
        self.think();
    }

    self = spawner;

    spawn_tdeath(monster.origin, monster);

    if (monster.health > 0) {
        if (self.spawnflags & SPAWNER_FLAG_ANGRY) {
            if (activator.classname == "player") {
                monster.enemy = activator;
            } else {
                self = monster;
                monster.enemy = checkclient();
                self = spawner;

                if (!monster.enemy) {
                    monster.enemy = find(world, classname, "player");
                }
            }

            if (monster.enemy) {
                monster.think = FoundTarget;
                monster.nextthink = time + 0.01;
            }
        }
    }
};

void() info_monster_spawn = {
    entity spawner;

    // setup monster
    spawner = self;
    self = spawn();

    self.origin = spawner.origin;
    self.angles = spawner.angles;
    self.target = spawner.target;
    self.squad = spawner.squad;
    self.io_send = spawner.io_send;
    self.spawnflags = spawner.spawnflags;

    if (self.spawnflags & SPAWNER_FLAG_NO_TELEFLASH) {
        self.spawnflags-= SPAWNER_FLAG_NO_TELEFLASH;
    }

    if (self.spawnflags & SPAWNER_FLAG_ANGRY) {
        self.spawnflags-= SPAWNER_FLAG_ANGRY;
    }

    // spawn function
    spawner.think();

    if (!self) {
        return;
    }

    spawner.use = SpawnerUse;
    self.nextthink = 0;

    // cache model (don't use setmodel)
    spawner.model = self.model;
    self.modelindex = 0;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    spawner.max_health = self.health;
    self.health = 0;

    spawner.enemy = self;

    self = spawner;
};
