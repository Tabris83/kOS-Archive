FOR P IN SHIP:PARTS {
  LOG ("MODULES FOR PART NAMED " + P:NAME) TO MODLIST.
  LOG P:MODULES TO MODLIST.
}
SET MOD TO P:GETMODULE("some name here").
LOG ("These are all the things that I can currently USE GETFIELD AND SETFIELD ON IN " + MOD:NAME + ":") TO NAMELIST.
LOG MOD:ALLFIELDS TO NAMELIST.
LOG ("These are all the things that I can currently USE DOEVENT ON IN " +  MOD:NAME + ":") TO NAMELIST.
LOG MOD:ALLEVENTS TO NAMELIST.
LOG ("These are all the things that I can currently USE DOACTION ON IN " +  MOD:NAME + ":") TO NAMELIST.
LOG MOD:ALLACTIONS TO NAMELIST.