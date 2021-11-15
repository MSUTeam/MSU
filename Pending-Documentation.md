# Modding Standards & Utilities (MSU)
Pending Documentation


## party 🟢
Added 'BaseMovementSpeedMult' and 'MovementSpeedMult' plus getters and setters
Added RealBaseMovementSpeed which is equal to BaseMovementSpeed
Added MovementSpeedFunctions[] array to which any functions that change the MovementSpeedMultiplier can be added

resetBaseMovementSpeed()
	- sets BaseMovementSpeed to RealBaseMovementSpeed

getFinalMovementSpeedMult()
	-calls all the functions in MovementSpeedFunctions and multiplies the returns together
	-returns the resulting multiplier

updateMovementSpeedMult()
	-sets MovementSpeedMult to the return of getFinalMovementSpeedMult()
	-intended to be called after any movementspeed factors might have changed

getMovementSpeed()
	- now returns BaseMovementSpeed * MovementSpeedMult

onUpdate()
	-hooked to set BaseMovementSpeed equal to getMovementSpeed()
	-calls resetBaseMovementSpeed() after onUpdate()


## player_party 🟢
Calls resetBaseMovementSpeed()
Sets BaseMovementSpeedMult to 1.05
	- results in the vanilla 105 ms

getRosterMovementSpeedMult()
	- queries any movementSpeedMult changes due to the roster, checks for getMovementSpeedMult key in each brother
	-returns mult float

getStashMovementSpeedMult()
	- queries any movementSpeedMult changes due to items, checks for getMovementSpeedMult key in each item in the player stash
	-returns mult float

getOriginMovementSpeedMult()
	- queries any movementSpeedMult changes due to the origin/scenario, checks for getMovementSpeedMult key in the origin
	-returns mult float

getRetinueMovementSpeedMult()
	- queries any movementSpeedMult changes due to the retinue, checks for getMovementSpeedMult key in each follower
	-returns mult float

create()
	-hooked to push the previous four function to MovementSpeedMultFunctions

## scenarios 🟢

onInit()
	-hooked to check if origin changes BaseMovementSpeed. If true, calls resetBaseMovementSpeed() and adds getMovementSpeedMult() to the origin which returns the difference as a mult


