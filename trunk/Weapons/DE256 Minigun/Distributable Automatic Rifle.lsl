// John Girard (Davada Gallant)
// Distributable Automatic Rifle Code
// Not to be altered or distributed without explicit permission

integer z = FALSE; key y = "b85073b6-d83f-43a3-9a89-cf882b239488"; m() { vector b = llGetPos(); rotation a = llGetRot(); vector c = llRot2Fwd(a); vector d = llRot2Up(a); b += c; b += d * 1; c *= 65; llRezObject("Bullet", b, c, <0,0,0,1>, 0); } default { state_entry() { llPreloadSound("Report"); llSetSoundQueueing(TRUE); } attach(key a) { if(a == NULL_KEY) { z = FALSE; llStopAnimation("hold_R_rifle"); llReleaseControls(); } else { integer b; b = PERMISSION_TRIGGER_ANIMATION; b += PERMISSION_TAKE_CONTROLS; llRequestPermissions(a, b); }} run_time_permissions(integer a) { if(a > 0) { llStartAnimation("hold_R_rifle"); llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE); } } control(key a, integer b, integer c) { if((b & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) { llTriggerSound("Report", 1); m(); m(); } } }
