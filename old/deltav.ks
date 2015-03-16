//Current Available Delta V

CLEARSCREEN.
set Mwet to SHIP:MASS.
set Mdry to SHIP:DRYMASS.
set Sisp to 0.
set Sthr to 0.
set GM to ship:body:mu.
set R to ship:body:radius. 
set LocG to GM/(R^2).
LIST ENGINES IN myVariable.
FOR eng IN myVariable 
{
     Set Sisp to eng:ISP.
     set Sthr to eng:MAXTHRUST.
}
PRINT LocG.
PRINT Sisp.
PRINT Sthr.
PRINT "DV = " + (LN(Mwet/Mdry))*Sisp*LocG.
