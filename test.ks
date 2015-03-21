clearscreen.
set loop to 10.
lock steering to PROGRADE.
until loop = 0
{
	print "facing:   " + ship:facing.
	print "Prograde: " + PROGRADE.
	print "Diff:     " + (ship:facing - ship:PROGRADE).
	set f to ship:facing.
	set p to ship:PROGRADE.
	set d to (ship:facing - ship:PROGRADE).
	set err to (p + d).
	print round((err - f):pitch,3).
	print round((err - f):yaw,3).
	print round((err - f):roll,3).
	if (err - f):pitch = 0 {print "works".} else {print "don't work".}
	wait 0.05.
	set loop to loop - 1.
}