// Davada Gallant (John Girard), WWIIOLers
// Distributable Bullet Code

key z = "b85073b6-d83f-43a3-9a89-cf882b239488";f() { llMakeExplosion(5, 0.1, 0.01, 2, .5, z, <0,0,0>); } default { on_rez(integer a) { llResetScript(); } state_entry() { llSetStatus(STATUS_PHYSICS, TRUE); llSetStatus(STATUS_DIE_AT_EDGE, TRUE); llSetBuoyancy(0.1); llSetDamage(0); } collision_start(integer a) { f(); llDie(); } touch_start(integer a) { f(); llDie();} land_collision_start(vector a) {f();llDie(); }}
