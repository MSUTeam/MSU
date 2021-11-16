# Modding Standards & Utilities (MSU)
Pending Documentation

#Party:
setRealBaseMovementSpeed(_speed):
	- sets this.m.RealBaseMovementSpeed
getRealBaseMovementSpeed(_speed):
	- returns this.m.RealBaseMovementSpeed
setMovementSpeed(_speed):
	- overwritten vanilla function
	- calls setBaseMovementSpeedMult with _speed / 100.0
	- represents the move away from hardcoded BaseMovementSpeed values and towards multipliers	
getSlowdownPerUnitMovementSpeedMult():
	- extracted from onUpdate 
	- returns mult based on troop number	
getGlobalMovementSpeedMult():
	- extracted from onUpdate 
	- added to MovementSpeedMultFunctions
getRoadMovementSpeedMult():
	- extracted from onUpdate 
	- added to MovementSpeedMultFunctions
getNightTimeMovementSpeedMult():
	- extracted from onUpdate 
	- added to MovementSpeedMultFunctions
getRiverMovementSpeedMult(): 
	- extracted from onUpdate 
	- added to MovementSpeedMultFunctions
getNotPlayerMovementSpeedMult():
	- extracted from onUpdate 
	- added to MovementSpeedMultFunctions	
//add to current doc
getMovementSpeed(_update = false):
	- if _update is true, first runs updateMovementSpeedMult() to set the movementSpeedMult to the currently applicable value
getTimeDelta():
	- extracted from onUpdate, returns time since last update
#Changed Functions:
onSerialise():
	- Adds flags to record BaseMovementSpeedMult and RealBaseMovementSpeed
	- Uses flags to be non-savegame-breaking
onDeserialise():
	- calls setBaseMovementSpeedMult() and setRealBaseMovementSpeed()
#Overwritten Functions:
onUpdate():
	- extracted delta calculation into getTimeDelta
	- extracted speed multipliers 
	- speed is now derived by this line: 
		"local speed = this.getMovementSpeed(true) * delta;"
##World.Common
this.Const.World.Common.assignTroops():
	- Hooked to call setBaseMovementSpeedMult() on the '_party' with the 'MovementSpeedMult' value of the 'p' template
	- Hooked to call resetBaseMovementSpeed() on the '_party', to set it back to 100.
	- Reason: The 'MovementSpeedMult' value of the template was applied directly to the BaseMovementSpeed, while it is now an independent value.