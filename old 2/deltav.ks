//Current Available Delta V

CLEARSCREEN.
lock iniOP to 14400. //4hours in sec.
set currOP to SHIP:OBT:PERIOD.
set Mwet to SHIP:MASS.
set Mdry to SHIP:DRYMASS.
set Sisp to 0.
set Sthr to 0.


set GM to ship:body:mu.
set R to ship:body:radius. 
set LocG to GM/(R^2).

LIST ENGINES IN myVariable.
FOR eng IN myVariable {
     Set Sisp to eng:ISP.
     set Sthr to eng:THRUST.
}.

PRINT LocG.
PRINT Sisp.
PRINT Sthr.
PRINT "DV = " + (LN(Mwet/Mdry))*Sisp*LocG.


PRINT "ORBITAL PERIOD.".

