declare parameter mode, Fap, Fpe.

until mode = 0
{
	if mode = 5
	{
		set warp to 0.
		until t <= 0
		{
			set t to (ETA:PERIAPSIS - 120).
			unlock steering.
			wait 1.
			set warp to 3.
			PRINT "Warping to PE at Warp Mode 3" AT (0,6).
			PRINT "Time to PE: " + t AT (0,7).
			if t <= 30 {set warp to 0. lock steering to PROGRADE. set mode to 6.}
		}
	}
	else if mode  = 6
	{
		lock Sval to PROGRADE.
		wait 2.
		set flag to 0.
		//facing check.
		set f to ship:facing.
		set p to ship:PROGRADE.
		set d to (ship:facing - ship:PROGRADE).
		set err to (p + d).
		
		if (err - f):pitch = 0 AND (err - f):yaw = 0
		{
			until (SHIP:APOAPSIS >= (Fap *0.98)) AND (SHIP:APOAPSIS <= (Fap *1.02))
			{
				set Sval to SHIP:PROGRADE.
				if SHIP:APOAPSIS < Fap * 0.25 {set Tval to 1.}
				else if SHIP:APOAPSIS > (Fap *0.25) AND SHIP:APOAPSIS < Fap * 0.5 {set Tval to 0.75.}
				else if SHIP:APOAPSIS > (Fap *0.5) AND SHIP:APOAPSIS < Fap * 0.75 {set Tval to 0.5.}
				else if SHIP:APOAPSIS > (Fap *0.75) AND SHIP:APOAPSIS < Fap * 0.85 {set Tval to 0.1.}
				else if SHIP:APOAPSIS > (Fap *0.85) AND SHIP:APOAPSIS < Fap * 0.99 {set Tval to 0.05.}
				else if SHIP:APOAPSIS >= Fap {set Tval to 0. PRINT "Apoapsis Raised to : " + round(SHIP:APOAPSIS /1000,2) AT (0,7).}
				if (SHIP:APOAPSIS >= (Fap *0.98)) AND (SHIP:APOAPSIS <= (Fap *1.02)) {set mode to 7. set Tval to 0. set t to TIME:SECONDS.}
				LOCK THROTTLE to Tval.
				PRINT "Throttle at: " + Tval*100 +"%                            " AT (0,6).
			}
		}
	}
	else if mode = 7
	{
		set warp to 0.
		until t <= 0
		{
			set t to (ETA:APOAPSIS - 120).
			unlock steering.
			wait 1.
			set warp to 3.
			PRINT "Warping to AP at Warp Mode 3" AT (0,6).
			PRINT "Time to AP: " + t AT (0,7).
			if t <= 30 {set warp to 0. lock steering to PROGRADE. set mode to 8.}
		}
	}
	else if mode  = 8
	{
		lock Sval to PROGRADE.
		wait 2.
		set flag to 0.
		//facing check.
		set f to ship:facing.
		set p to ship:PROGRADE.
		set d to (ship:facing - ship:PROGRADE).
		set err to (p + d).
		
		if (err - f):pitch = 0 AND (err - f):yaw = 0
		{
			until (SHIP:PERIAPSIS >= (Fpe *0.98)) AND (SHIP:APOAPSIS <= (Fpe *1.02))
			{
				set Sval to SHIP:PROGRADE.
				if SHIP:PERIAPSIS < Fpe * 0.25 {set Tval to 1.}
				else if SHIP:PERIAPSIS > (Fpe *0.25) AND SHIP:PERIAPSIS < Fpe * 0.5 {set Tval to 0.75.}
				else if SHIP:PERIAPSIS > (Fpe *0.5) AND SHIP:PERIAPSIS < Fpe * 0.75 {set Tval to 0.5.}
				else if SHIP:PERIAPSIS > (Fpe *0.75) AND SHIP:PERIAPSIS < Fpe * 0.85 {set Tval to 0.1.}
				else if SHIP:PERIAPSIS > (Fpe *0.85) AND SHIP:PERIAPSIS < Fpe * 0.99 {set Tval to 0.05.}
				else if SHIP:PERIAPSIS >= Fpe {set Tval to 0. PRINT "Periapsis Raised to : " + round(SHIP:PERIAPSIS /1000,2) AT (0,7).}
				if (SHIP:PERIAPSIS >= (Fpe *0.98)) AND (SHIP:PERIAPSIS <= (Fpe *1.02)) {set mode to 7.}
				LOCK THROTTLE to Tval.
				PRINT "Throttle at: " + Tval*100 +"%                            " AT (0,6).
			}
		}
	}
	
	//gui
	PRINT "Mode: " + mode +" " AT (0,2).
	PRINT "Target AP: " + round(Fap/1000) +"Km - Current AP: " + round(SHIP:APOAPSIS/1000) +"Km " AT (0,3).
	PRINT "Target PE: " + round(Fpe/1000) +"Km - Current PE: " + round(SHIP:PERIAPSIS/1000) +"Km " AT (0,4).
	PRINT "Current ALT: " +round(SHIP:ALTITUDE/1000) +"Km " AT (0,5).
	
	//warp, steering & throttle control
	LOCK THROTTLE to Tval.
	LOCK WARP to Wval.
	LOCK STEERING to Sval.
	
	//staging
	if STAGE:LIQUIDFUEL < 1 AND mode > 1
	{
		set OTval to Tval.
		set Tval to 0.
		PRINT "Staging".
		STAGE.
		set Tval to OTval.		
	}
	WHEN SHIP:LIQUIDFUEL < 1 THEN
	{
		clearscreen.
		PRINT "Out of Fuel".
		PRINT "Terminating Program".
		set mode to 0.
	}
}