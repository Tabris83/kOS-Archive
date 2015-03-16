// creates a node 60 seconds from now with
// prograde = 100 m/s
//SET X TO NODE(TIME:SECONDS+60, 0, 0, 100).

//ADD X.            // adds maneuver to flight plan

//PRINT X:PROGRADE. // prints 100.
//PRINT X:ETA.      // prints seconds till maneuver
//PRINT X:DELTAV.    // prints delta-v vector

//REMOVE X.         // remove node from flight plan

// Create a blank node
SET X TO NODE(0, 0, 0, 0).

ADD X.                 // add Node to flight plan
SET X:PROGRADE to 500. // set prograde dV to 500 m/s
SET X:ETA to 30.       // Set to 30 sec from now

PRINT X:ORBIT:APOAPSIS.  // apoapsis after maneuver
PRINT X:ORBIT:PERIAPSIS. // periapsis after maneuver