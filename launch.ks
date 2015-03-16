//Script to Launch to Orbit
clearscreen.
set Tval to 0.
set Wval to 0.
set Sval to 0.
set ship:control:pilotmainthrottle to 0.
set Fap to 2868750. //geo sync
set Fpe to 1225160. // 2/3 resonant
if BODY:ATM:EXISTS {set Iap to BODY:ATM:HEIGHT *2.}
else {set Iap to BODY:RADIUS.}
set Ipe to Iap *0.9.
set pitchPercent to 0.
//countdown
set cd to 10.
set mode to -1.
on ag10 {set mode to 1.}
on abort {set mode to 0. set THROTTLE to 0.}
on ag9 {set Tval to 1. LOCK STEERING TO HEADING(90,90).	STAGE. set mode to 2.}

until mode = 0
{
	if mode = 1 //countdown
	{
		wait 1.
		if cd = 2
		{
			set Tval to 1.
		}
		if cd = 1
		{
			set Sval to UP.
		}
		set cd to cd - 1.		
		if cd = 0
		{
			PRINT "LIFTOFF                 " AT (1,2).
			STAGE.
			set mode to 2.
		}
	}
	else if mode = 2 //ascent
	{
		WHEN SHIP:ALTITUDE > 1000 THEN
		{
				lock pitchPercent to (floor(altitude) * 100) / 60000.
				lock Sval to heading(90,max(round(90 - (90 * pitchPercent / 100)),10)).
				PRINT "Current Pitch: " + round(90 - (90 * pitchPercent / 100)) +" " AT (0,6).
		}
		WHEN SHIP:APOAPSIS >= (Iap * 1.01) THEN
		{
			set Tval to 0.
			set mode to 3.
		}
		if SHIP:ALTITUDE > 40000 {run ant(1).}
	}
	else if mode = 3 //raise PE
	{
		set Sval to SHIP:PROGRADE.
		if (SHIP:ALTITUDE > 70000) AND (ETA:APOAPSIS > 120)
			{
				set Wval to 5.
			}
			if ETA:APOAPSIS < 120
			{
				set Wval to 0.
				set mode to 4.
			}
			set WARP to Wval.
			PRINT "Warping at: " + Wval +"                            " AT (0,6).		
	}
	else if mode = 4
	{
		set Sval to SHIP:PROGRADE.
		wait 2.
		until (SHIP:PERIAPSIS >= (Ipe *0.98)) AND (SHIP:PERIAPSIS <= (Ipe *1.02))
		{
			if SHIP:PERIAPSIS < (Ipe * 0.5) {set Tval to 1. set Sval to SHIP:PROGRADE -R(0,25,0). PRINT "LEVEL 1      " AT (0,6).}
			else if SHIP:PERIAPSIS <= (Ipe * 0.75) {set Tval to 0.5. set Sval to SHIP:PROGRADE -R(0,15,0). PRINT "LEVEL 2      " AT (0,6).}
			else if SHIP:PERIAPSIS <= (Ipe * 0.9) {set Tval to 0.25. set Sval to SHIP:PROGRADE -R(0,5,0). PRINT "LEVEL 3      " AT (0,6).}
			else if SHIP:PERIAPSIS > Ipe  {set Tval to 0. set mode to 5. set Sval to SHIP:PROGRADE. PRINT "LEVEL 4      " AT (0,6).}			
		}
	}
	
	//gui
	PRINT "Mode: " + mode +" " AT (0,2).
	PRINT "Target AP: " + round(Iap/1000) +"Km - Current AP: " + round(SHIP:APOAPSIS/1000) +"Km " AT (0,3).
	PRINT "Target PE: " + round(Ipe/1000) +"Km - Current PE: " + round(SHIP:PERIAPSIS/1000) +"Km " AT (0,4).
	PRINT "Current ALT: " +round(SHIP:ALTITUDE/1000) +"Km " AT (0,5).
	
	//warp, steering & throttle control
	LOCK THROTTLE to Tval.
	LOCK WARP to Wval.
	LOCK STEERING to Sval.
	
	//staging
	IF STAGE:LIQUIDFUEL < 1 AND mode > 1
	{
		set OTval to Tval.
		set Tval to 0.
		wait 0.5.
		PRINT "Staging".
		STAGE.
		wait 1.
		set Tval to OTval.		
	}
	WHEN SHIP:LIQUIDFUEL < 1 THEN
	{
		PRINT "Out of Fuel".
		PRINT "Terminating Program".
		set mode to 0.
	}
}