declare Fap, Fpe, mode.
SET t TO TIME:SECONDS + ETA:PERIAPSIS.
set x to node(t,0,0,1).
add x.
set nTval to 0.
set nDV to 0.
set Wrate to 0.
//gui additions
set a to 13.
set lines to 0.
PRINT "|              NODE STATISTICS               |" AT (0,12).
until lines = 10
{
	PRINT "|                                            |" AT (0,a).
	set a to a + 1.
	set lines to lines + 1.
}
if mode >= 10 AND mode < 20 {set mode to 20.}
until mode = 0
{
	if mode = 20 //raising AP
	{
		until x:orbit:APOAPSIS >= Fap AND x:orbit:APOAPSIS < Fap *1.02
			{
				PRINT "Node Target AP: " + round(Fap/1000,2) AT (1,14).
				PRINT "Node Actual AP: " + round(x:orbit:APOAPSIS/1000,2) AT (1,15).
				set x:prograde to x:prograde + 1.
				wait 0.01.
				if x:orbit:APOAPSIS >= Fap AND x:orbit:APOAPSIS < Fap *1.02
				{
					set mode to 21.
				}
			}
	}
	if mode = 21
	{
		LOCK STEERING TO X.
		wait 5.
		set mode to 22.
	}
	if mode = 22 //warping to node
	{
		set Tval to 0.
		set warp to 0.
		until x:ETA < 180
		{
			LOCK STEERING TO X.
			if x:ETA >= 300
			{
				set Wrate to 4.
				wait 0.5.
			}
			if x:ETA <= 301
			{
				set Wrate to 6.				
				wait 0.5.
			}
			if x:ETA < 180
			{
				set Wrate to 0.				
				wait 0.5.
				set mode to 23.
			}
			set warp to Wrate.
		}
	}
	if mode = 23
	{
		LOCK STEERING TO X.
		set nDV to x:deltav:mag.
		wait 2.
		until x:deltav:mag < 0.5
		{
			if x:deltav:mag > nDV / 2
			{
				set nTval to 1.
			}
			else if x:deltav:mag > nDV / 2 AND x:deltav:mag < nDV / 3
			{
				set nTval to 0.5.
			}
			else if x:deltav:mag > nDV / 3 AND x:deltav:mag < nDV / 5
			{
				set nTval to 0.25.
			}
			else if x:deltav:mag > nDV / 5 AND x:deltav:mag < nDV / 7
			{
				set nTval to 0.1.
			}
			if x:deltav:mag < 0.05
			{
				set nTval to 0.
			}
			LOCK THROTTLE to nTval.
		}
	}
	//throttle control
	set FTVAL to Tval.
	LOCK THROTTLE to FTval.
	//warp control
	//set warp to Wrate.
	
	//gui
	PRINT "Ship Name: " + SHIP:NAME + " Mode:  " + mode +" " AT (1,1).
	PRINT "Node Target AP: " + round(Fap/1000,2) AT (1,14).
	PRINT "Node Actual AP: " + round(x:orbit:APOAPSIS/1000,2) AT (1,15).
	PRINT "Node ETA: " + x:ETA AT (1,16).
	PRINT "Warp Speed: " + Wrate +" " AT (1,17).
	PRINT "THROTTLE: " + Tval +" " AT (1,18).
}
	
	
	