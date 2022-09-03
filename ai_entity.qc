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
    entity oself, monster;

    self.health = 1;
    self.think = AiBullseyeReset;
    self.nextthink = time + 0.1;

    monster = find(world, targetname, self.target);
    oself = self;

    while (monster) {

        if (monster.health > 0 && monster.th_missile) {
            self = monster;

            if (self.enemy && self.oldenemy.classname != "player") {
                self.oldenemy = self.enemy;
            }

            self.enemy = oself;
            self.th_missile();
        }

        monster = find(monster, targetname, oself.target);
    }

    self = oself;
}

void ai_bullseye() = {
    self.use = AiBullseyeUse;
}
