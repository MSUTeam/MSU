::mods_hookExactClass("entity/tactical/actor", function(o) {
	local onMovementStart = o.onMovementStart;
	o.onMovementStart = function ( _tile, _numTiles )
	{
		onMovementStart(_tile, _numTiles);
		this.m.IsMoving = true;
		this.m.Skills.onMovementStarted(_tile, _numTiles);
		this.m.IsMoving = false;
	}

	local onMovementFinish = o.onMovementFinish;
	o.onMovementFinish = function ( _tile )
	{
		onMovementFinish(_tile);
		this.m.IsMoving = true;
		this.m.Skills.onMovementFinished(_tile);
		this.m.IsMoving = false;
	}

	local onMovementStep = o.onMovementStep;
	o.onMovementStep = function( _tile, _levelDifference )
	{
		local ret = onMovementStep(_tile, _levelDifference);

		if (ret)
		{
			this.m.Skills.onMovementStep(_tile, _levelDifference);
		}

		return ret;
	}

	local onDeath = o.onDeath;
	o.onDeath = function( _killer, _skill, _tile, _fatalityType )
	{
		local deathTile = this.isPlacedOnMap() ? this.getTile() : null;
		this.m.Skills.onDeathWithInfo(_killer, _skill, deathTile, _tile, _fatalityType);

		onDeath(_killer, _skill, _tile, _fatalityType);

		if (!::Tactical.State.isFleeing() && deathTile != null)
		{
			local factions = ::Tactical.Entities.getAllInstances();

			foreach (f in factions)
			{
				foreach (actor in f)
				{
					if (actor.getID() != this.getID())
					{
						actor.getSkills().onOtherActorDeath(_killer, this, _skill, deathTile, _tile, _fatalityType);
					}
				}
			}
		}
	}

	// This function is called during `onExecute` of the `ai_pickup_weapon` behavior
	// This hook is necessary to ensure that the correct items array is passed to the `payForAction` function
	// TODO - needs discussion because in vanilla even if the AI picks up a weapon AND a shield, they only pay the cost ONCE i.e. 4 AP
	// However with this change now they will be able to pick up a weapon with 0 Cost if they have Quick Hands - this conflicts with vanilla behavior
	// We could leave this hook out completely but that will leave a loop hole in MSU implementation regarding skills which may affect AP cost of picking
	// up items from the ground
	local pickupMeleeWeaponAndShield = o.pickupMeleeWeaponAndShield;
	o.pickupMeleeWeaponAndShield = function( _tile )
	{
		local itemsBefore = _entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Mainhand);
		itemsBefore.extend(_entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Offhand));

		local ret = pickupMeleeWeaponAndShield(_tile);

		local itemsAfter = _entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Mainhand);
		itemsAfter.extend(_entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Offhand));
		this.getItems().payForAction(itemsAfter.filter(@(idx, item) itemsBefore.find(item) == null));

		return ret;
	}

	o.getMainhandItem <- function()
	{
		return this.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	}

	o.getOffhandItem <- function()
	{
		return this.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
	}

	o.getHeadItem <- function()
	{
		return this.getItems().getItemAtSlot(::Const.ItemSlot.Head);
	}

	o.getBodyItem <- function()
	{
		return this.getItems().getItemAtSlot(::Const.ItemSlot.Body);
	}

	o.isArmedWithOneHandedWeapon <- function()
	{
		local item = this.getMainhandItem();
		return item != null && item.isItemType(::Const.Items.ItemType.OneHanded);
	}

	o.isArmedWithTwoHandedWeapon <- function()
	{
		local item = this.getMainhandItem();
		return item != null && item.isItemType(::Const.Items.ItemType.TwoHanded);
	}

	o.getRemainingArmorFraction <- function( _bodyPart = null )
	{
		local totalArmorMax = 0;
		local currentArmor = 0;

		if (_bodyPart == null)
		{
			totalArmorMax = this.getArmorMax(::Const.BodyPart.Head) + this.getArmorMax(::Const.BodyPart.Body);
			currentArmor = this.getArmor(::Const.BodyPart.Head) + this.getArmor(::Const.BodyPart.Body);
		}
		else
		{
			totalArmorMax = this.getArmorMax(_bodyPart);
			currentArmor = this.getArmor(_bodyPart);
		}

		return totalArmorMax > 0 ? currentArmor / (totalArmorMax * 1.0) : 0.0;
	}

	o.isEngagedInMelee <- function()
	{
		return this.isPlacedOnMap() && this.getTile().hasZoneOfControlOtherThan(this.getAlliedFactions());
	}

	o.isDoubleGrippingWeapon <- function()
	{
		local s = this.getSkills().getSkillByID("special.double_grip");

		return s != null && !s.isHidden();
	}

	o.addExcludedInjuries <- function(_injuries)
	{
		foreach (injury in _injuries)
		{
			if (this.m.ExcludedInjuries.find(injury) == null)
			{
				this.m.ExcludedInjuries.push(injury);
			}
		}
	}
});
