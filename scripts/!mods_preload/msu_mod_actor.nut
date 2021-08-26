local gt = this.getroottable();

gt.Const.MSU.modActor <- function() {
	::mods_hookExactClass("entity/tactical/actor", function(o) {	
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
		
		o.getActorsAtDistanceAsArray <- function( _distance, _relation = this.Const.FactionRelation.Any )
		{
			if (!this.isPlacedOnMap())
			{
				return [];
			}
			
			local myTile = this.getTile();
			
			if (myTile == null)
			{
				return [];
			}

			if (!("Entities" in this.Tactical))
			{
				return [];
			}

			if (this.Tactical.Entities == null)
			{
				return [];
			}
			
			local actors = this.Tactical.Entities.getAllInstancesAsArray();		
			local result = [];
			
			foreach( a in actors )
			{
				if (a == null)
				{
					continue;
				}
				
				if (a.getID() == this.getID())
				{
					continue;
				}
				
				if (!a.isPlacedOnMap())
				{
					continue;
				}
				
				if (a.getTile() == null)
				{
					continue;
				}

				if (a.getTile().getDistanceTo(myTile) != _distance)
				{
					continue;
				}
				
				if (_relation == this.Const.FactionRelation.SameFaction && a.getFaction() != this.getFaction())
				{
					continue;
				}
				
				if (_relation == this.Const.FactionRelation.Allied && !a.isAlliedWith(this))
				{
					continue;
				}
				
				if (_relation == this.Const.FactionRelation.Enemy && a.isAlliedWith(this))
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
			
			local myTile = this.getTile();
			
			if (myTile == null)
			{
				return [];
			}

			if (!("Entities" in this.Tactical))
			{
				return [];
			}

			if (this.Tactical.Entities == null)
			{
				return [];
			}
			
			local actors = this.Tactical.Entities.getAllInstancesAsArray();
			local result = [];

			foreach( a in actors )
			{
				if (a == null)
				{
					continue;
				}
				
				if (a.getID() == this.getID())
				{
					continue;
				}

				if (!a.isPlacedOnMap())
				{
					continue;
				}
				
				if (a.getTile() == null)
				{
					continue;
				}				

				if (a.getTile().getDistanceTo(myTile) > _distance)
				{
					continue;
				}
				
				if (_relation == this.Const.FactionRelation.SameFaction && a.getFaction() != this.getFaction())
				{
					continue;
				}
				
				if (_relation == this.Const.FactionRelation.Allied && !a.isAlliedWith(this))
				{
					continue;
				}
				
				if (_relation == this.Const.FactionRelation.Enemy && a.isAlliedWith(this))
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
			
			if (actors.len() == 0)
			{
				return null;
			}
			
			return actors[this.Math.rand(0, actors.len()-1)];
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
		
		o.isEngagedInMelee <- function()
		{
			if (!this.isPlacedOnMap() || this.getTile() == null)
			{
				return false;
			}
			
			return this.getTile().hasZoneOfControlOtherThan(this.getAlliedFactions())			
		}
		
		o.isDoubleGrippingWeapon <- function()
		{
			local s = this.getSkills().getSkillByID("special.double_grip");
			if (s == null || s.isHidden())
			{
				return false;
			}
			
			return true;			
		}
	});
}