local gt = this.getroottable();

gt.MSU.modParty <- function ()
{
	::mods_hookExactClass("entity/world/party", function(o) {
		o.m.RealBaseMovementSpeed <- o.m.BaseMovementSpeed;
		o.m.BaseMovementSpeedMult <- 1.0;
		o.m.MovementSpeedMult <- 1.0;
		o.m.MovementSpeedFunctions <- [];

		local create = o.create;
		o.create = function()
		{
			create();
			this.m.MovementSpeedMultFunctions.push(this.getBaseMovementSpeedMult);
		}

		o.resetBaseMovementSpeed <- function()
		{
			this.setBaseMovementSpeed(this.m.RealBaseMovementSpeed);
		};

		o.getBaseMovementSpeedMult <- function()
		{
			return this.m.BaseMovementSpeedMult;
		};

		o.setBaseMovementSpeedMult <- function(_mult)
		{
			this.m.BaseMovementSpeedMult = _mult;
		};

		o.getMovementSpeedMult <- function()
		{
			return this.m.MovementSpeedMult;
		};

		o.setMovementSpeedMult <- function(_mult)
		{
			this.m.MovementSpeedMult = _mult;
		};

		o.getFinalMovementSpeedMult <- function()
		{
			local mult = 1.0;
			foreach(func in this.m.MovementSpeedMultFunctions){
				mult *= func();
			};
			return mult;
		};

		o.updateMovementSpeedMult <- function()
		{
			this.setMovementSpeedMult(this.getFinalMovementSpeedMult());
		};

		o.getMovementSpeed <- function()
		{
			return this.getBaseMovementSpeed() * this.getMovementSpeedMult();
		};

		local old_onUpdate = o.onUpdate;
		o.onUpdate = function()
		{
			this.setBaseMovementSpeed(this.getMovementSpeed());
			onUpdate();
			this.resetBaseMovementSpeed();
		};
	});

	::mods_hookExactClass("entity/world/player_party", function(o) {
		o.resetBaseMovementSpeed();
		o.setBaseMovementSpeedMult(1.05);

		local create = o.create;
		o.create = function()
		{
			create();
			this.m.MovementSpeedMultFunctions.push(this.getRosterMovementSpeedMult);
			this.m.MovementSpeedMultFunctions.push(this.getStashMovementSpeedMult);
			this.m.MovementSpeedMultFunctions.push(this.getOriginMovementSpeedMult);
			this.m.MovementSpeedMultFunctions.push(this.getRetinueMovementSpeedMult);
		}

		o.getRosterMovementSpeedMult <- function()
		{
			local mult = 1.0;
			local roster = this.World.getPlayerRoster().getAll();
			foreach(bro in roster){
				if ("getMovementSpeedMult" in bro){
					mult *= bro.getMovementSpeedMult();
				};
			};
			return mult;
		}

		o.getStashMovementSpeedMult <- function()
		{
			local mult = 1.0;
			local inventory = this.World.Assets.getStash();
			foreach(item in inventory.getItems()){
				if ("getMovementSpeedMult" in item){
					mult *= item.getMovementSpeedMult();
				};
			};
			return mult;
		}

		o.getOriginMovementSpeedMult <- function()
		{
			local mult = 1.0;
			local origin = this.World.Assets.getOrigin();
			if ("getMovementSpeedMult" in origin){
				mult *= origin.getMovementSpeedMult();
			};
			return mult;
		};

		o.getRetinueMovementSpeedMult <- function(){
			local mult = 1.0;
			local retinue = this.World.Retinue;
			foreach(follower in retinue.m.Followers){
				if ("getMovementSpeedMult" in follower){
					mult *= follower.getMovementSpeedMult();
				};
			};
			return mult;
		};

	});
}