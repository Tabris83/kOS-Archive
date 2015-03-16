CLEARSCREEN.
REMOVE NEXTNODE.
SET tgt TO TARGET.
SET t TO TIME:SECONDS.
SET lBreak TO SHIP:OBT:PERIOD.
PRINT t.
PRINT tgt.
SET x TO node(t,0,0,0).
add x.
SET flag TO 0.
SET Stime TO 0.
SET Etime TO 0.
PRINT tgt:NAME +", "+ tgt:ALTITUDE +", "+ tgt:RADIUS.
//SET encbody TO ENCOUNTER:BODY.
UNTIL X:ORBIT:APOAPSIS >= (tgt:ALTITUDE + tgt:RADIUS)
{
	SET x:prograde TO x:prograde + 5.
}
UNTIL X:ETA > 0
{
	SET X:ETA TO X:ETA+500.
}
UNTIL flag = 1
{
	SET Stime TO TIME:SECONDS.	
	//LOG ENCOUNTER + "," + X:ORBIT:BODY + ","  + X:ETA TO tgt:NAME.
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
	IF X:ETA > lBreak*3 { PRINT "NO Solution Found". BREAK.}.
}
if flag = 1 
{
	PRINT "ENCOUNTER".
	UNTIL ENCOUNTER:PERIAPSIS <= tgt:RADIUS
	{
		SET X:ETA TO X:ETA+0.01.
		PRINT "Refining Orbit" AT(0,5). 
		PRINT "Current PERIAPSIS " + ENCOUNTER:PERIAPSIS AT(0,6).
		PRINT "Target PERIAPSIS " + tgt:RADIUS AT(1,7).
		PRINT "Target Error "  + (ENCOUNTER:PERIAPSIS - tgt:RADIUS) AT(5,8).
		if ENCOUNTER:PERIAPSIS <= tgt:RADIUS {SET flag TO 2. PRINT "Orbit Refined".}
	}
}
if flag = 2
{
	SET Etime TO TIME:SECONDS.
	//LOCK STEERING TO X:BURNVECTOR.
	WAIT 1.
	SET flag TO 3.
}
if flag = 3
{
	SET tTime TO Etime - Stime.
	CLEARSCREEN.
	PRINT "it TOok " + round(tTime,2) + " Seconds TO find a solution".
	PRINT "Target: " + tgt:NAME.
	PRINT "Time TO Burn: " +  Round(X:ETA,2) + "m".
	PRINT "Delta-V Required: " + X:DeltaV:MAG.
	PRINT "PERIAPSIS at Target: " + ENCOUNTER:PERIAPSIS/1000 +"km".
	run burn.
}
	
