CLEARSCREEN.
REMOVE NEXTNODE.
set tgt to MUN.
SET t to TIME:SECONDS.
SET lBreak to SHIP:OBT:PERIOD.
PRINT t.
PRINT tgt.
set x to node(t,0,0,0).
add x.
set flag to 0.
PRINT tgt:NAME.
//SET encbody TO ENCOUNTER:BODY.
until X:ORBIT:APOAPSIS >=tgt:ALTITUDE
{
	set x:prograde to x:prograde + 5.
}
WHEN flag = 1 THEN
{
	PRINT "ENCOUNTER".
	LOCK STEERING TO NEXTNODE.
}
until X:ETA > 0
{
	SET X:ETA to X:ETA+500.
}
until flag = 1
{
		
	LOG ENCOUNTER + "," + tgt + ","  + X:ETA to tgt:NAME.
	SET X:ETA to X:ETA+0.5.
	if ENCOUNTER = tgt {SET flag TO 1. PRINT "ENCOUNTER Found". PRINT flag.}.
	IF X:ETA > lBreak*2 { PRINT "NO Solution Found". BREAK.}.
}
	
