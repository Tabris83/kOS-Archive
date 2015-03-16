//Script to Launch to Orbit
clearscreen.
set Tval to 0.
set Fap to 2868750. //geo sync
set Fpe to 1225160. // 2/3 resonant
set Iap to BODY:ATM:HEIGHT *2.
set Ipe to Iap *0.9.
set flag to 0.
set Scount to 4.



//GUI
	PRINT "+--------------------------------------------+".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "|                                            |".
	PRINT "+--------------------------------------------+".

//countdown

set mode to -1.
on ag10 {set mode to 1.}
on abort {set mode to 0. set THROTTLE to 0.}
on ag9 
{
	set Tval to 1.
	LOCK STEERING TO HEADING(90,90).
	set mode to 2.
}
set cd to 10.
until mode = 0
{
	if mode = 1
	{
		until cd = 0
		{
			PRINT "T-"+cd + " " AT (1,1).
			wait 1.
			if cd = 2
			{
				PRINT "Throttle up" AT (1,2).
				set Tval to 1.
			}
			if cd = 1
			{
				PRINT "Locking Steering" AT (1,2).
				LOCK STEERING TO HEADING(90,90).
			}
			set cd to cd - 1.
		}
		if cd = 0
		{
			PRINT "LIFTOFF                 " AT (1,2).
			STAGE.
			set mode to 2.
		}
	}
	if mode = 2
	{
		WHEN SHIP:ALTITUDE  > 10000 THEN
		{
			LOCK STEERING TO HEADING(90,60).
			set mode to 3.
		}
	}
	if mode = 3
	{
		WHEN SHIP:ALTITUDE > 20000 THEN
		{
			LOCK STEERING TO HEADING(90,45).
			set mode to 4.
		}
	}
	if mode = 4
	{
		WHEN SHIP:ALTITUDE > 30000 THEN
		{
			LOCK STEERING TO HEADING(90,30).
			set mode to 5.
		}
	}
	if mode = 5
	{
		WHEN SHIP:ALTITUDE > 40000 THEN
		{
			LOCK STEERING TO HEADING(90,0).
			set Tval to 0.75.
			set mode to 6.
		}
	}
	if mode = 6
	{
		WHEN SHIP:APOAPSIS >= (Iap / 2) THEN
		{
			set Tval to 0.3.
			set mode to 7.
		}
		run ant.
	}
	if mode = 7
	{
		WHEN SHIP:APOAPSIS >= Iap THEN
		{
			set Tval to 0.
			set mode to 8.
		}
	}
	if mode = 8 // warp
	{
		set Tval to 0.
		wait 4.
		if SHIP:ALTITUDE > 70000 AND ETA:APOAPSIS > 120
		{
			set warp to 4.
			set mode to 9.
		}
		else if ETA:APOAPSIS > 500
		{
			set warp to 5.
			set mode to 9.
		}
	}
	if mode = 9
	{
		if SHIP:ALTITUDE >= (SHIP:APOAPSIS /1.1)
		{
			set warp to 0.
			set mode to 10.
		}
	}
	if mode = 10 //raise PE
	{
		LOCK STEERING to PROGRADE -R(0,10,0).
		wait 5.
		until SHIP:PERIAPSIS >= Ipe
		{
			set Tval to 1.
			LOCK THROTTLE to Tval.
			LOCK STEERING to PROGRADE -R(0,10,0).
		}
		set mode to 11.
	}
	if mode = 11 //orbit setting
	{
		LOCK THROTTLE to 0.
		wait 1.
		run node(Fap, Fpe, mode).
	}
	//staging
	IF STAGE:LIQUIDFUEL < 1 AND mode > 1
	{
		set OTval to Tval.
		set Tval to 0.
		wait 0.5.
		PRINT "Staging".
		STAGE.
		set Tval to OTval.
		wait 1.
	}
	WHEN SHIP:LIQUIDFUEL < 1 THEN
	{
		PRINT "Out of Fuel".
		PRINT "Terminating Program".
		set mode to 0.
	}
	set FTVAL to Tval.
	LOCK THROTTLE to FTval.
	
	//GUI Data
	PRINT "Ship Name: " + SHIP:NAME + " Mode:  " + mode +" " AT (1,1).
	PRINT "Stage: " + STAGE:NUMBER +" " AT (1,2).
	PRINT "-------------ORBIT STATISTICS---------------" AT (1,3).
	PRINT "Target AP: " + round(Iap/1000,2) +"Km" +" " AT (1,4).
	PRINT " Current AP: " + round(SHIP:APOAPSIS/1000,2) + "Km " AT (18,4).
	PRINT "Target PE: " + round(Ipe/1000,2) +"Km" +" " AT (1,5).
	PRINT " Current PE: " + round(SHIP:PERIAPSIS/1000,2) + "Km " AT (18,5).
	PRINT "Time until AP: " + round(ETA:APOAPSIS,2) AT (1,6).
	PRINT "Time until PE: " + round(ETA:PERIAPSIS,2) AT (1,7).
	PRINT "Orbital Inclination: " + round(OBT:INCLINATION,3) + " " AT (1,8).
	PRINT "Orbital Period: " + round((OBT:PERIOD/60)/60,2) + " " AT (1,9).
	
	
}
