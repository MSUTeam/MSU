local gt = this.getroottable();

gt.MSU.modParty <- function ()
{
	::mods_hookExactClass("entity/world/party", function(o) {
		o.m.RealBaseMovementSpeed <- o.m.BaseMovementSpeed;
		o.m.BaseMovementSpeedMult <- 1.0;
		o.m.MovementSpeedMult <- 1.0;
		o.m.MovementSpeedMultFunctions <- [];

		local create = o.create;
		o.create = function()
		{
			create();
			this.m.MovementSpeedMultFunctions.push(this.getBaseMovementSpeedMult);
		}

		o.setBaseMovementSpeed <- function(_speed)
		{
			this.m.BaseMovementSpeed = _speed;
		}

		o.resetBaseMovementSpeed <- function()
		{
			this.setBaseMovementSpeed(this.m.RealBaseMovementSpeed);
		}

		o.getBaseMovementSpeedMult <- function()
		{
			return this.m.BaseMovementSpeedMult;
		}

		o.setBaseMovementSpeedMult <- function(_mult)
		{
			this.m.BaseMovementSpeedMult = _mult;
		}

		o.getMovementSpeedMult <- function()
		{
			return this.m.MovementSpeedMult;
		}

		o.setMovementSpeedMult <- function(_mult)
		{
			this.m.MovementSpeedMult = _mult;
		}

		o.getFinalMovementSpeedMult <- function()
		{
			local mult = 1.0;
			foreach(func in this.m.MovementSpeedMultFunctions)
			{
				mult *= func();
			}
			return mult;
		}

		o.updateMovementSpeedMult <- function()
		{
			this.setMovementSpeedMult(this.getFinalMovementSpeedMult());
		}

		o.getMovementSpeed <- function()
		{
			return this.getBaseMovementSpeed() * this.getMovementSpeedMult();
		}

		local old_onUpdate = o.onUpdate;
		o.onUpdate = function()
		{
			this.updateMovementSpeedMult();
			this.setBaseMovementSpeed(this.getMovementSpeed());
			old_onUpdate();
			this.resetBaseMovementSpeed();
		}
	});
}