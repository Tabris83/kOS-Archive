declare parameter type.
SET c16 TO SHIP:PARTSDUBBED("Communotron 16").
SET c32 TO SHIP:PARTSDUBBED("Communotron 32").
SET cm1 TO SHIP:PARTSDUBBED("Comms DTS-M1").
SET c88 TO SHIP:PARTSDUBBED("Communotron 88-88").
SET antennae TO LIST().
FOR antenna IN c16 {
    antennae:ADD(antenna).
}
FOR antenna IN c32 {
    antennae:ADD(antenna).
}
FOR antenna IN cm1 {
    antennae:ADD(antenna).
}
FOR antenna IN c88 {
    antennae:ADD(antenna).
}
if type = 1
{
	FOR antenna IN antennae 
	{
		//antenna:GETMODULE("ModuleAnimateGeneric"):DOACTION("activate antenna", true).
		antenna:GETMODULE("ModuleRTAntenna"):DOACTION("ACTIVATE", TRUE).
	}
}
if type = 2
{
	FOR antenna IN antennae 
	{
		//antenna:GETMODULE("ModuleAnimateGeneric"):DOACTION("toggle antenna", true).
		antenna:GETMODULE("ModuleRTAntenna"):DOACTION("toggle", TRUE).
	}
}
if type = 3
{
	FOR antenna IN antennae 
	{
		//antenna:GETMODULE("ModuleAnimateGeneric"):DOACTION("deactivate antenna", true).
		antenna:GETMODULE("ModuleRTAntenna"):DOACTION("deactivate", TRUE).
	}
}