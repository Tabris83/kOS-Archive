CLEARSCREEN.
//Current Available Delta V
set bflag to 0.
set wflag to 0.
set X to NEXTNODE.
CLEARSCREEN.
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
LIST ENGINES IN myEng.
FOR eng IN myEng 
{
	set isp to isp + eng:ISP.
	set Sthrlim to Sthrlim + (eng:MAXTHRUST * (eng:THRUSTLIMIT / 100)).
}
//MATH
set avgisp to isp / myEng:length.
set DV to (LN(Mwet/Mdry)) * avgisp * LocG.
set ve to avgisp * LocG.
set Btime to (Mwet * ve / Sthrlim) * (1 - e ^(-ndv / ve)).
set nTime to X:ETA - (Btime/2).
//Delta-V Check
if DV < X:DeltaV:MAG 
{
	PRINT "You are not going to " + tgt + "Today.".
}
ELSE
{
	PRINT "STARTING BURN".
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
	if nTime < SHIP:OBT:PERIOD
	{
		SET WARP to 3.
		PRINT "WARPING to Burn".		
		set wflag to 1.
	}	
}
UNTIL X:ETA  = (Btime * 2)
	{
		if wflag = 1
		{	
			PRINT "WARPING UNTIL " + (Btime * 2) AT (10,10).
			
			//PRINT "impulse power".
			LOCK STEERING to X:BURNVECTOR.
			if X:ETA = (Btime * 2)
			{
				SET wflag to 2.
			}
		}
		if wflag = 2
		{
			PRINT "                                                              " AT (10,10).
			set WARP to 0.
			PRINT "Leaving Warp" AT (10,10).
			set wflag to 3.
		}
		if wflag = 3
		{
			
		}
		
	}
