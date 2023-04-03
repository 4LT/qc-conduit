void HuntTarget();

void ai_monitor() = {}

void AiBullseyeResetMonsters() = {
    entity monster, oself;

    oself = self;
    monster = find(world, targetname, oself.target);

    while(monster) {
        if (
                monster.health > 0 &&
                monster.oldenemy &&
                monster.enemy.health <= 0
        ) {
            self = monster;
            self.enemy = self.oldenemy;
            HuntTarget();
        }

        monster = find(monster, targetname, oself.target);
    }

    remove(oself);
}

void AiBullseyeReset() = {
    entity oself;

    self.health = 0;
    oself = self;
    self = spawn();
    self.target = oself.target;
    self.think = AiBullseyeResetMonsters;
    self.nextthink = time + 0.7;
}

void AiBullseyeUse() = {
    entity oself, monster, targ_ent;
    vector tr_start, tr_end;

    self.health = 1;
    self.think = AiBullseyeReset;
    self.nextthink = time + 0.1;

    monster = find(world, targetname, self.target);
    oself = self;

    while (monster) {

        if (monster.health > 0 && monster.th_missile) {
            traceline(oself.origin, oself.origin + '0 0 1', FALSE, oself);

            if (trace_startsolid) {
                targ_ent = trace_ent;
            } else {
                targ_ent = world;
            }

            tr_start = monster.origin + '0 0 16';
            tr_end = oself.origin;

            traceline(tr_start, tr_end, FALSE, monster);
            
            if (
                trace_fraction > 0.99
                || (targ_ent != world && trace_ent == targ_ent)
            ) {
                self = monster;

                if (self.enemy && self.oldenemy.classname != "player") {
                    self.oldenemy = self.enemy;
                }

                self.enemy = oself;
                self.th_missile();
            }
        }

        monster = find(monster, targetname, oself.target);
    }

    self = oself;
}

void ai_bullseye() = {
    self.movetype = MOVETYPE_NONE;
    self.use = AiBullseyeUse;
}
