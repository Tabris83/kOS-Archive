DECLARE PARAMETER SatAlt.
set x to node(TIME:SECONDS +60,0,0,0).
add x.
until X:ORBIT:APOAPSIS >=SatAlt
{
	set x:prograde to x:prograde + 5.
}
PRINT "Node DeltaV is: " + X:DELTAV:MAG.
LOCK STEERING TO NEXTNODE.