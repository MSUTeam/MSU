local gt = this.getroottable();

gt.MSU.setupDamageTypeSystem <- function ()
{
	this.Const.Tactical.HitInfo.DamageType <- null;
	this.Const.Tactical.HitInfo.DamageTypeProbability <- 1.0;

	this.Const.Damage <- {
		function addNewDamageType ( _damageType, _injuriesOnHead, _injuriesOnBody, _damageTypeName = "" )
		{
			if (_damageType in this.DamageType)
			{
				this.logError("addNewDamageType: \'" + _damageType + "\' already exists.");
				return;
			}

			local n = 0;
			foreach (d in this.DamageType)
			{
				if (d > n)
				{
					n = d;
				}
			}

			this.DamageType[_damageType] <- n << 1;

			this.DamageTypeInjuries.push(
				{
					DamageType = this.DamageType[_damageType],
					Injuries = {
						Head = _injuriesOnHead,
						Body = _injuriesOnBody
					}
				}
			);

			if (_damageTypeName = "")
			{
				_damageTypeName = _damageType;
			}

			this.Const.Damage.DamageTypeName.push(_damageTypeName);
		}

		function getDamageTypeName( _damageType )
		{
			// local idx = log(_damageType)/log(2) + 1;
			// if (idx == idx.tointeger() && idx < this.DamageTypeName.len())
			// {
			// 	return this.DamageTypeName[idx];
			// }

			local d = 0;
			for (local i = 0; i < this.Const.Damage.DamageType.len(); i++)
			{
				if (d == _damageType)
				{
					return this.Const.Items.DamageTypeName[i];
				}
				d = d == 0 ? 1 : d << 1;
			}

			this.logError("getDamageTypeName: _damageType \'" + _damageType + "\' does not exist");

			return "";
		}

		function getDamageTypeInjuries ( _damageType )
		{	
			local idx = log(_damageType)/log(2) + 1;
			if (idx == idx.tointeger() && idx < this.DamageTypeInjuries.len())
			{
				return this.DamageTypeInjuries[idx].Injuries;
			}

			this.logError("getDamageTypeInjuries: _damageType \'" + _damageType + "\' does not exist");

			return null;			
		}

		function setDamageTypeInjuries ( _damageType, _injuriesOnHead, _injuriesOnBody )
		{
			local injuries = this.getDamageTypeInjuries(_damageType);

			if (injuries == null)
			{
				this.logError("setDamageTypeInjuries: _damageType \'" + _damageType + "\' does not exist");
				return;
			}

			injuries.Injuries.Head = _injuriesOnHead;
			injuries.Injuries.Body = _injuriesOnBody;
		}

		function getApplicableInjuries ( _damageType, _bodyPart, _targetEntity = null )
		{
			local injuries = [];

			foreach (d in this.DamageType)
			{
				if (_damageType == d)
				{
					local inj = this.getDamageTypeInjuries(d);
					if (inj != null)
					{
						injuries = _bodyPart == this.Const.BodyPart.Head ? inj.Head : inj.Body;
						break;
					}
				}
			}

			if (_targetEntity != null && injuries.len() > 0)
			{
				foreach (injury in _targetEntity.m.ExcludedInjuries)
				{
					if (injuries.find(injury) != null)
					{
						injuries.remove(injury);
					}
				}
			}

			return injuries;
		}
	};

	this.Const.Damage.DamageType <- {
			None = 0,
			Blunt = 1,
			Piercing = 2
			Cutting = 4,
			Burning = 8
	};

	this.Const.Damage.DamageTypeName <- [
		"No Damage Type",
		"Blunt",
		"Piercing",
		"Cutting",
		"Burning"
	];

	this.Const.Damage.DamageTypeInjuries <- [
		{
			DamageType = this.Const.Damage.DamageType.None,
			Injuries = {
				Head = [],
				Body = []
			}
		},
		{
			DamageType = this.Const.Damage.DamageType.Blunt,
			Injuries = {
				Head = this.Const.Injury.BluntHead,
				Body = this.Const.Injury.BluntBody
			}
		},
		{
			DamageType = this.Const.Damage.DamageType.Piercing,
			Injuries = {
				Head = this.Const.Injury.PiercingHead,
				Body = this.Const.Injury.PiercingBody
			}
		},
		{
			DamageType = this.Const.Damage.DamageType.Cutting,
			Injuries = {
				Head = this.Const.Injury.CuttingHead,
				Body = this.Const.Injury.CuttingBody
			}
		},
		{
			DamageType = this.Const.Damage.DamageType.Burning,
			Injuries = {
				Head = this.Const.Injury.BurningHead,
				Body = this.Const.Injury.BurningBody
			}
		}
	];
}
