CLEARSCREEN.
SAS OFF.
SET THROTTLE TO 0.

set Tval to 0.

set Tap to 250000.
set Tpe to 250000.

set runmode to 2.
if ALT:RADAR < 50
{
	set runmode to 1.
}

until runmode = 0
{
	if runmode = 1
	{
		LOCK STEERING TO UP.
		set Tval to 1.
		set runmode to 2.
	}
	else if runmode = 2
	{
		LOCK STEERING TO HEADING (90,90).
		set Tval to 1.
		if SHIP:ALTITUDE > 10000
		{
			set runmode to 3.
		}
	}
	else if runmode = 3
	{
		set Tpt to MAX(5, 90 * (1- ALT:RADAR / 50000)).
		LOCK STEERING TO HEADING(90, Tpt).
		set Tval to 1.
		
		if SHIP:APOAPSIS > Tap
		{
			set runmode to 4.
		}
	}
	else if runmode = 4
	{
		LOCK STEERING TO HEADING (90,3).
		set Tval to 0.
		if (SHIP:ALTITUDE > 70000) AND (ETA:APOAPSIS > 60) AND (VERTICALSPEED > 0)
		{
			if WARP = 0
			{
				WAIT 1.
				SET WARP TO 3.
			}
			else if ETA:APOAPSIS < 90
			{
				SET WARP TO 0.
				SET runmode TO 5.
			}
		}
	}
	else if runmode = 5
	{
		if (ETA:APOAPSIS < 5) OR (VERTICALSPEED < 0)
		{
			set Tval to 1.
		}
		if (SHIP:PERIAPSIS > Tpe ) OR (SHIP:PERIAPSIS > (Tap *0.95))
		{
			set Tval to 0.
			set runmode to 10.
		}
	}
	else if runmode = 10
	{
		set Tval to 0.
		PANELS ON.
		UNLOCK STEERING.
		
		SET c16 TO SHIP:PARTSDUBBED("Communotron 16").
		SET c32 TO SHIP:PARTSDUBBED("Communotron 32").
		SET cm1 TO SHIP:PARTSDUBBED("Comms DTS-M1").
		SET c88 TO SHIP:PARTSDUBBED("Communotron 88-88").
		SET antennae TO LIST().
		FOR antenna IN c16 
		{
			antennae:ADD(antenna).
		}
		FOR antenna IN c32 
		{
			antennae:ADD(antenna).
		}
		FOR antenna IN cm1 
		{
			antennae:ADD(antenna).
		}
		FOR antenna IN c88 
		{
			antennae:ADD(antenna).
		}
		FOR antenna IN antennae 
		{
			antenna:GETMODULE("ModuleAnimateGeneric"):DOACTION("toggle antenna", true).
		}
		set runmode to 0.
	}
	
	if STAGE:LIQUIDFUEL < 1
	{
		LOCK THROTTLE TO 0.
		WAIT 2.
		STAGE.
		WAIT 3.
		LOCK THROTTLE TO Tval.
	}
	
	set FTVAL to Tval.
	LOCK THROTTLE TO FTVAL.
	
	print "RUNMODE: " + runmode + " " at (5,4).
	print "ALTITUDE: " + round(SHIP:ALTITUDE) + " " at (5,5).
	print "APOAPSIS: " + round(SHIP:APOAPSIS) + " " at (5,6).
	print "PERIAPSIS: " + round(SHIP:PERIAPSIS) + " " at (5,7).
	print "ETA to AP: " + round(ETA:APOAPSIS) + " " at (5,8).
	print "Stage fuel: " + round(STAGE:LIQUIDFUEL) + " " at (5,9).
}