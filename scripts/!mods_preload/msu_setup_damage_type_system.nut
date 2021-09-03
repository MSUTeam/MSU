local gt = this.getroottable();

gt.MSU.setupDamageTypeSystem <- function ()
{
	this.Const.Tactical.HitInfo.DamageType <- null;
	this.Const.Tactical.HitInfo.DamageWeight <- 100;

	this.Const.Damage <- {
		function addNewDamageType(_damageType, _injuriesOnHead, _injuriesOnBody)
		{
			local n = 0;
			foreach (d in this.DamageType)
			{
				if (d > n)
				{
					n = d;
				}
			}

			this.DamageType[_damageType] <- n * 2;

			this.InjuriesForDamageType.push(
				{
					DamageType = this.DamageType[_damageType],
					Injuries = {
						Head = _injuriesOnHead,
						Body = _injuriesOnBody
					}
				}
			);
		}

		function getInjuriesForDamageType(_damageType)
		{
			foreach (i in this.InjuriesForDamageType)
			{
				if (i.DamageType == _damageType)
				{
					return i.Injuries;
				}
			}

			return null;
		}

		function getApplicableInjuries(_damageType, _bodyPart, _targetEntity = null)
		{
			local injuries = [];

			foreach (d in this.DamageType)
			{
				if (_damageType == d)
				{
					local inj  = this.getInjuriesForDamageType(d);
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
	this.Const.Damage.InjuriesForDamageType <- [
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
