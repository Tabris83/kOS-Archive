declare parameter Fap, Fpe, pmode.
CLEARSCREEN.
set mode to -1.

set Wrate to 0.
if pmode >= 10 {set mode to 20.}
until mode = 0
{
	if mode = 20 //warp to PERIAPSIS
	{
		set Wrate to 0.
		wait 3.
		LOCK STEERING to SHIP:PROGRADE.
		until ETA:PERIAPSIS <= 180
		{
			//set t TO TIME:SECONDS + ETA:PERIAPSIS.
			set Wrate to 5.
			PRINT "warping to PE" AT (0,1).
			PRINT Wrate AT (0,2).
			PRINT ETA:PERIAPSIS AT (0,3).
			//set warp to Wrate.
			wait 0.01.
			if ETA:PERIAPSIS <= 180{set Wrate to 0.}
		}
		set warp to Wrate.
		set mode to 21.
	}
	if mode = 21
	{
		set Wrate to 0.
		PRINT mode.
		PRINT INCOMMRANGE.
		LOCK STEERING to SHIP:PROGRADE.
		until (SHIP:APOAPSIS >= Fap) AND (SHIP:APOAPSIS < Fap *1.02)
		{
			LOCK STEERING to SHIP:PROGRADE.
			PRINT "burning".
			if SHIP:APOAPSIS < Fap * 0.3 {set Tval to 1.}
			else if SHIP:APOAPSIS < Fap * 0.5 {set Tval to 0.75.}
			else if SHIP:APOAPSIS < Fap * 0.75 {set Tval to 0.5.}
			else if SHIP:APOAPSIS < Fap * 0.85 {set Tval to 0.25.}
			else if SHIP:APOAPSIS < Fap * 0.9 {set Tval to 0.1.}
			else if SHIP:APOAPSIS >= Fap {set Tval to 0.}
		}
	}

	//throttle control
	set FTVAL to Tval.
	LOCK THROTTLE to FTval.
	//warp control
	set warp to Wrate.
	
	//gui
	PRINT "Ship Name: " + SHIP:NAME + " Mode:  " + mode +" " AT (1,1).
	PRINT "Warp Speed: " + Wrate +" " AT (1,17).
	PRINT "THROTTLE: " + Tval +" " AT (1,18).
}
	
	
	