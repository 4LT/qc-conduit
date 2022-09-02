static float notify_running;

void(float notify_type) SquadNotify = {
    entity squaddie, self_temp;

    // Don't recurse
    if ((!notify_running) && self.squad && self.squad != "") {
        notify_running = TRUE;

        squaddie = find(self, squad, self.squad);

        while (squaddie != self) {
            if (squaddie != world) {
                if (notify_type == SQNOTIFY_ENEMY) {
                    squaddie.enemy = self.enemy;

                    self_temp = self;
                    self = squaddie;
                    FoundTarget();
                    self = self_temp;
                }
            }

            squaddie = find(squaddie, squad, self.squad);
        }

        notify_running = FALSE;
    }
};
