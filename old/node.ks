declare parameter a.

set x to node(0,0,0,0).
add x.

until X:ORBIT:APOAPSIS >=a
{
	set x:prograde to x:prograde + 5.
}