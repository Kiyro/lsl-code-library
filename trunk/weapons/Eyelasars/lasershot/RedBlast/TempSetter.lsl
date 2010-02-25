default
{
    on_rez(integer param)
    {
        if (param == 0) return;
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
        llSetPrimitiveParams([PRIM_TEMP_ON_REZ,TRUE]);
    }
}