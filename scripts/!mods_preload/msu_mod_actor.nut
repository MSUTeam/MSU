local gt = this.getroottable();

gt.MSU.modActor <- function() {
	::mods_hookExactClass("entity/tactical/actor", function(o) {
		local onInit =  o.onInit;
		o.onInit = function()
		{
			onInit();
			this.m.Skills.add(this.new("scripts/skills/effects/msu_injuries_handler_effect"));
		}

		local onMovementStart = o.onMovementStart;
		o.onMovementStart = function ( _tile, _numTiles ) {
			onMovementStart(_tile, _numTiles);
			this.m.IsMoving = true;
			this.m.Skills.onMovementStarted( _tile, _numTiles );
			this.m.IsMoving = false;
		}

		local onMovementFinish = o.onMovementFinish;
		o.onMovementFinish = function ( _tile ) {
			onMovementFinish(_tile);
			this.m.IsMoving = true;
			this.m.Skills.onMovementFinished( _tile );
			this.m.IsMoving = false;
		}

		// local setDirty = o.setDirty;
		// o.setDirty = function( _value )
		// {
		// 	if (_value)
		// 	{
		// 		this.getSkills().update();
		// 	}
		// 	setDirty(_value);
		// }

		o.getActorsAtDistanceAsArray <- function( _distance, _relation = this.Const.FactionRelation.Any )
		{
			if (!this.isPlacedOnMap())
			{
				return [];
			}

			local actors = this.Tactical.Entities.getAllInstancesAsArray();
			local result = [];

			foreach( a in actors )
			{
				if (a == null || a.getID() == this.getID() || !a.isPlacedOnMap() ||
					  a.getTile().getDistanceTo(this.getTile()) != _distance ||
						_relation == this.Const.FactionRelation.SameFaction && a.getFaction() != this.getFaction() ||
						_relation == this.Const.FactionRelation.Allied && !a.isAlliedWith(this) ||
						_relation == this.Const.FactionRelation.Enemy && a.isAlliedWith(this)
					)
				{
					continue;
				}

				result.push(a);
			}

			return result;
		}

		o.getRandomActorAtDistance <- function ( _distance, _relation = this.Const.FactionRelation.Any )
		{
			local actors = this.getActorsAtDistanceAsArray(_distance, _relation);

			if (actors.len() == 0)
			{
				return null;
			}

			return actors[this.Math.rand(0, actors.len()-1)];
		}

		o.getActorsWithinDistanceAsArray <- function ( _distance, _relation = this.Const.FactionRelation.Any )
		{
			if (!this.isPlacedOnMap())
			{
				return [];
			}

			local actors = this.Tactical.Entities.getAllInstancesAsArray();
			local result = [];

			foreach( a in actors )
			{
				if (a == null || a.getID() == this.getID() || !a.isPlacedOnMap() ||
					  a.getTile().getDistanceTo(this.getTile()) > _distance ||
						_relation == this.Const.FactionRelation.SameFaction && a.getFaction() != this.getFaction() ||
						_relation == this.Const.FactionRelation.Allied && !a.isAlliedWith(this) ||
						_relation == this.Const.FactionRelation.Enemy && a.isAlliedWith(this)
					)
				{
					continue;
				}

				result.push(a);
			}

			return result;
		}

		o.getRandomActorWithinDistance <- function( _distance, _relation = this.Const.FactionRelation.Any )
		{
			local actors = this.getActorsWithinDistanceAsArray(_distance, _relation);

			return actors.len() == 0 ? null : actors[this.Math.rand(0, actors.len()-1)];
		}

		o.getMainhandItem <- function()
		{
			return this.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		}

		o.getOffhandItem <- function()
		{
			return this.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		}

		o.getHeadItem <- function()
		{
			return this.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		}

		o.getBodyItem <- function()
		{
			return this.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		}

		o.isArmedWithOneHandedWeapon <- function()
		{
			local item = this.getMainhandItem();
			return item != null && item.isItemType(this.Const.Items.ItemType.OneHanded);
		}

		o.isArmedWithMeleeOrUnarmed <- function()
		{
			return this.isArmedWithMeleeWeapon() || this.getSkills().hasSkill("actives.hand_to_hand");
		}

		o.isArmedWithTwoHandedWeapon <- function()
		{
			local item = this.getMainhandItem();
			return item != null && item.isItemType(this.Const.Items.ItemType.TwoHanded);
		}

		o.getRemainingArmorFraction <- function()
		{
			local fraction = 0;

			local maxHeadArmor = this.getArmorMax(this.Const.BodyPart.Head);
			if (maxHeadArmor != 0)
			{
				fraction += this.getArmor(this.Const.BodyPart.Head) / (maxHeadArmor * 1.0);
			}

			local maxBodyArmor = this.getArmorMax(this.Const.BodyPart.Body);
			if (maxBodyArmor != 0)
			{
				fraction += this.getArmor(this.Const.BodyPart.Body) / (maxBodyArmor * 1.0);
			}

			return fraction;
		}

		o.getTotalArmorStaminaModifier <- function()
		{
			local ret = 0;
			local bodyArmor = this.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
			local headArmor = this.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

			if (bodyArmor != null)
			{
				ret += bodyArmor.getStaminaModifier();
			}

			if (headArmor != null)
			{
				ret += headArmor.getStaminaModifier();
			}

			return ret;
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
}
