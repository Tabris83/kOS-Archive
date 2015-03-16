CLEARSCREEN.
//man node var
//REMOVE NEXTNODE.
SET tgt TO TARGET.
SET t TO TIME:SECONDS.
SET lBreak TO SHIP:OBT:PERIOD.
SET x TO node(t+60,0,0,0).
add x.
SET flag TO 0.
SET Stime TO 0.
SET Etime TO 0.
SET runmode to 1.
SET Stime TO TIME:SECONDS.
//node execution var
set bflag to 0.
set wflag to 0.
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
SET CONFIG:IPU TO 150.
until runmode = 0
{
		
		
	if runmode = 1 //maneuver node setting
	{
		UNTIL X:ORBIT:APOAPSIS >= (tgt:ALTITUDE + tgt:RADIUS)
		{
			SET x:prograde TO x:prograde + 5.
		}
		UNTIL flag = 1
		{			
			SET X:ETA TO X:ETA+0.5.
			if ENCOUNTER <> "none" 
			{	
				if ENCOUNTER:BODY:NAME = tgt:NAME
				{
					SET flag TO 1. 
				}
				ELSE
				{
					SET X:ETA TO X:ETA+0.5.			
				}
			}
			IF X:ETA > lBreak*3 { PRINT "NO Solution Found". BREAK.}.
		}
		if flag = 1 
		{
			UNTIL ENCOUNTER:PERIAPSIS <= (tgt:RADIUS *2.5)
			{
				SET X:ETA TO X:ETA+0.5.
				PRINT "Refining Orbit" AT(0,5). 
				PRINT "Current PERIAPSIS " + ENCOUNTER:PERIAPSIS AT(0,6).
				PRINT "Target PERIAPSIS " + tgt:RADIUS AT(1,7).
				PRINT "Target Error "  + (ENCOUNTER:PERIAPSIS - tgt:RADIUS) AT(5,8).
				if ENCOUNTER:PERIAPSIS <= (tgt:RADIUS *2.5) {SET flag TO 2. }
			}
		}
		if flag = 2
		{
			UNTIL ENCOUNTER:PERIAPSIS <= tgt:RADIUS
			{
				SET X:ETA TO X:ETA+0.01.
				PRINT "Refining Orbit" AT(0,5). 
				PRINT "Current PERIAPSIS " + ENCOUNTER:PERIAPSIS AT(0,6).
				PRINT "Target PERIAPSIS " + tgt:RADIUS AT(1,7).
				PRINT "Target Error "  + (ENCOUNTER:PERIAPSIS - tgt:RADIUS) AT(5,8).
				if ENCOUNTER:PERIAPSIS <= tgt:RADIUS {SET flag TO 3. }
			}
			WAIT 1.
			SET flag TO 3.
		}
		if flag = 3
		{
			SET Etime TO TIME:SECONDS.
			SET tTime TO Etime - Stime.
			CLEARSCREEN.
			PRINT "it Took " + round(tTime,2) + " Seconds TO find a solution".
			PRINT "Target: " + tgt:NAME.
			PRINT "Time TO Burn: " +  Round(X:ETA,2) + "s".
			PRINT "Delta-V Required: " + round(X:DeltaV:MAG,2) + "m/s".
			PRINT "PERIAPSIS at Target: " + round(ENCOUNTER:PERIAPSIS/1000,2) +"km".
			SET runmode to 2.
		}
	}
	else if runmode = 2 //MATH
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
		set runmode to 3.
	}
		//Delta-V Check
	else if runmode = 3 //maneuver node execution
	{
		if DV < X:DeltaV:MAG 
		{
			PRINT "You are not going to " + tgt:NAME + " Today.".
			BREAK.
		}
		ELSE
		{
			CLEARSCREEN.
			PRINT "PREPARING BURN".
			PRINT "Target: " + tgt:NAME.
			PRINT "Time to Burn: " +  round(nTime).
			PRINT "Delta-V Available: " +  round(DV) + " m/s".
			PRINT "Delta-V Required: " + Round(X:DeltaV:MAG) +" m/s".
			PRINT "Time Required For Burn: " + round(Btime,2) + " s".
			PRINT "PERIAPSIS at Target: " + round(ENCOUNTER:PERIAPSIS / 1000,2) +" km".
			set bflag to 1.
		}
		if bflag = 1
		{
			PRINT "TAKING DIRECT CONTROL".
			LOCK STEERING TO X:BURNVECTOR.
			WAIT 5.
			set bflag to 2.
		}
		if bflag = 2
		{
			//time control
			if nTime <= SHIP:OBT:PERIOD
			{
				SET WARP to 3.
				PRINT "WARPING to Burn".		
				set wflag to 1.
			}
			else if nTime >= SHIP:OBT:PERIOD
			{
				SET WARP to 4.
				PRINT "WARPING to Burn".		
				set wflag to 1.
			}
		}
		UNTIL X:ETA  = (Btime * 2) or X:ETA > 60
		{
			if wflag = 1
			{	
				PRINT "WARPING UNTIL " + round(Btime * 2) AT (10,10).
				LOCK STEERING to X:BURNVECTOR.
				if X:ETA <= (Btime * 2) or X:ETA > 60
				{
					set WARP to 0.
					SET wflag to 2.
				}
			}
			if wflag = 2
			{
				PRINT "                                                              " AT (10,10).
				PRINT "Leaving Warp" AT (10,10).
				set wflag to 3.
			}
			if wflag = 3
			{
				CLEARSCREEN.
				SET CONFIG:IPU TO 500.
				set thVal to 1.
				PRINT "Throttle Target: " + (ndv * thVal) +" m/s" AT (0,5).
				PRINT "Throttle set to: " + (thVal * 100) + "%" AT (0,8).
				UNTIL X:DeltaV:MAG = (ndv * 0.5) //burn 90%
				{
					PRINT "STARTING BURN" AT (0,1).
					PRINT "Target: " + tgt:NAME AT (0,2).
					PRINT "Delta-V Available: " +  round(DV) + " m/s" AT (0,3).
					PRINT "Delta-V Required: " + Round(X:DeltaV:MAG) +" m/s" AT (0,4).
					
					PRINT "Time Required For Burn: " + round(Btime,2) + " s" AT (0,6).
					PRINT "PERIAPSIS at Target: " + round(ENCOUNTER:PERIAPSIS / 1000,2) +" km" AT (0,7).
					
					LOCK THROTTLE TO thVal.
					
					// WHEN X:DeltaV:MAG <= (ndv * 0.5) THEN
					// {
						// set thVal TO 0.5.
						// PRINT "Throttle Target: " + (ndv * 0.5) +" m/s" AT (0,5).
						// PRINT "Throttle set to: " + (thVal * 100) + "%" AT (0,8).
					// }
					WHEN X:DeltaV:MAG <= (ndv * 0.25) THEN
					{
						set thVal TO 0.25.
						PRINT "Throttle Target: " + (ndv * 0.25) +" m/s" AT (0,5).
						PRINT "Throttle set to: " + (thVal * 100) + "%" AT (0,8).
					}
					WHEN X:DeltaV:MAG <= (ndv * 0.1) THEN
					{
						set thVal TO 0.1.
						PRINT "Throttle Target: " + (ndv * 0.1) +" m/s" AT (0,5).
						PRINT "Throttle set to: " + (thVal * 100) + "%" AT (0,8).
					}
					WHEN X:DeltaV:MAG <= 1 THEN
					{
						set thVal TO 0.
						set runmode to 0.
					}
				}
			}
		
		}
	}
SET CONFIG:IPU TO 150.	
}
	
