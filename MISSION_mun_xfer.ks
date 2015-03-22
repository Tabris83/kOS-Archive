declare parameter mode.
set t to TIME:SECONDS.
set x to node(t + ETA:PERIAPSIS,0,0,0).
add x.
set lBreak to SHIP:OBT:PERIOD.
set TARGET to Mun.
set tgt to TARGET.
set flag to -1.
set Mwet to SHIP:MASS.
set Mdry to SHIP:DRYMASS.
set Sthrlim to 0.
set GM to ship:body:mu.
set R to ship:body:radius. 
set LocG to GM/(R^2).
set isp to 0.
set Btime to 0.
set e to CONSTANT():E.
set ndv to X:DeltaV:MAG.

until mode = 0
{
	if mode = 5
	{		
		UNTIL X:ORBIT:APOAPSIS >= (tgt:ALTITUDE + tgt:RADIUS)
		{
			SET x:prograde TO x:prograde + 5.
		}
		UNTIL flag = 1
		{
			SET Stime TO TIME:SECONDS.	
			SET X:ETA TO X:ETA+0.5.
			if ENCOUNTER <> "none" 
			{	
				if ENCOUNTER:BODY:NAME = tgt:NAME
				{
					SET flag TO 1. 
					PRINT "ENCOUNTER Found". 
					PRINT flag.
				}
				ELSE
				{
					SET X:ETA TO X:ETA+0.5.
					PRINT "Still Searching" AT(0,5).
				}
			}
			IF X:ETA > lBreak*3 { PRINT "NO Solution Found". BREAK. set mode to 0.}.
		}
		if flag = 1 
		{
			PRINT "ENCOUNTER".
			UNTIL ENCOUNTER:PERIAPSIS <= tgt:RADIUS
			{
				SET X:ETA TO X:ETA+0.015.
				PRINT "Refining Orbit" AT(0,5). 
				PRINT "Current PERIAPSIS " + ENCOUNTER:PERIAPSIS AT(0,6).
				PRINT "Target PERIAPSIS " + tgt:RADIUS AT(1,7).
				PRINT "Target Error "  + (ENCOUNTER:PERIAPSIS - tgt:RADIUS) AT(5,8).
				if ENCOUNTER:PERIAPSIS <= tgt:RADIUS {SET mode to 6. PRINT "Orbit Refined".}
			}
		}
	}
	else if mode = 6
	{
		LIST ENGINES IN myEng.
		FOR eng IN myEng 
		{
			set isp to isp + eng:ISP.
			set Sthrlim to Sthrlim + (eng:MAXTHRUST * (eng:THRUSTLIMIT / 100)).
		}
		//MATH
		set ndv to X:DeltaV:MAG.
		set avgisp to isp / myEng:length.
		set DV to (LN(Mwet/Mdry)) * avgisp * LocG.
		set ve to avgisp * LocG.
		set Btime to (Mwet * ve / Sthrlim) * (1 - e ^(-ndv / ve)).
		set nTime to X:ETA - (Btime/2).
		LOCK Sval to x:Burnvector.
		set warp to 0.
		until x:eta <= nTime
		{
			set warp to 4.
			if nTime = 10 {set WARP to 0. set mode to 7.}
		}
	}
	else if mode = 7
	{
		set Sval to x:Burnvector.
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