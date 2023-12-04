__wrap void(string msg) objerror = {
    prior(msg);
    error("Fatal objerror call\n");
}
