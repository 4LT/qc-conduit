static float f_arg1;
static float f_arg2;
static float f_arg3;
static string s_arg1;
static string s_arg2;
static string s_arg3;
static string s_arg4;
static string s_arg5;
static string s_arg6;
static string s_arg7;

void(void(entity) fn) broadcast {
    entity client = find(world, classname, "player");

    while (client) {
        fn(client);
        client = find(client, classname, "player");
    }
}

static void clear_args() {
    s_arg1 = s_arg2 = s_arg3 = s_arg4 = s_arg5 = s_arg6 = s_arg7 = string_null;
    f_arg1 = f_arg2 = f_arg3 = 0;
}

static void(entity client) bcenterprint_cb {
    centerprint7(
        client,
        s_arg1,
        s_arg2,
        s_arg3,
        s_arg4,
        s_arg5,
        s_arg6,
        s_arg7
    );
}

void(string message) bcenterprint {
    clear_args();
    s_arg1 = message;
    broadcast(bcenterprint_cb);
}

void(string m1, string m2) bcenterprint2 {
    clear_args();
    s_arg1 = m1;
    s_arg2 = m2;
    broadcast(bcenterprint_cb);
}

void(string m1, string m2, string m3) bcenterprint3 {
    clear_args();
    s_arg1 = m1;
    s_arg2 = m2;
    s_arg3 = m3;
    broadcast(bcenterprint_cb);
}

static void(entity client) bsound_cb {
    sound(client, f_arg1, s_arg1, f_arg2, f_arg3);
}


void(float channel, string path, float volume, float attenuation) bsound {
    f_arg1 = channel;
    s_arg1 = path;
    f_arg2 = volume;
    f_arg3 = attenuation;
    broadcast(bsound_cb);
}
