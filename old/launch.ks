// My First Launcher.

WHEN SHIP:ALTITUDE > 10000 THEN {
    PRINT "Starting turn.  Aiming to 45 degree pitch.".
    LOCK STEERING TO HEADING(90,45). // east, 45 degrees pitch.
}
WHEN SHIP:ALTITUDE > 40000 THEN {
    PRINT "Starting flat part.  Aiming to horizon.".
    LOCK STEERING TO HEADING(90,0). // east, horizontal.
}
SET countdown TO 10.
PRINT "Counting down:".
UNTIL countdown = 0 {
    PRINT "..." + countdown.
    SET countdown TO countdown - 1.
    WAIT 1. // pauses the script here for 1 second.
}
PRINT "Main throttle up.  2 seconds to stabalize it.".
LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.
LOCK STEERING TO UP.
WAIT 2. // give throttle time to adjust.

// The section below replaces previous UNTIL loop:

WHEN STAGE:LIQUIDFUEL < 0.001 THEN {
    PRINT "No liquidfuel.  Attempting to stage.".
    STAGE.
    PRESERVE.
}
WAIT UNTIL SHIP:ALTITUDE > 70000. // pause here until ship is high up.

// NOTE that it is vital to not just let the script end right away
// here.  Once a kOS script just ends, it releases all the controls
// back to manual piloting so that you can fly the ship by hand again.
// If the program just ended here, then that would cause the throttle
// to turn back off again right away and nothing would happen.