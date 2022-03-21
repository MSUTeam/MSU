::Const.Combat.DivertedAttackHitChancePenalty <- 15;
::Const.Combat.DivertedAttackDamageMult <- 0.75;

::Const.ItemActionOrder <- {
	First = 0,
	Early = 1000,
	Any = 50000,
	BeforeLast = 60000
	Last = 70000,
	VeryLast = 80000
};

::Const.FactionRelation <- {
	Any = 0,
	SameFaction = 1,
	Allied = 2,
	Enemy = 3
};

::Const.Damage <- {
	function addNewDamageType ( _damageType, _injuriesOnHead, _injuriesOnBody, _damageTypeName = "" )
	{
		if (_damageType in this.DamageType)
		{
			throw ::MSU.Exception.DuplicateKey(_damageType);
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

		this.DamageTypeInjuries.push({
			DamageType = this.DamageType[_damageType],
			Injuries = {
				Head = _injuriesOnHead,
				Body = _injuriesOnBody
			}
		});

		if (_damageTypeName = "")
		{
			_damageTypeName = _damageType;
		}

		::Const.Damage.DamageTypeName.push(_damageTypeName);
	}

	function getDamageTypeName( _damageType )
	{
		local idx = ::MSU.Math.log2int(_damageType) + 1;
		if (idx == idx.tointeger() && idx < this.DamageTypeName.len())
		{
			return this.DamageTypeName[idx];
		}
		throw ::MSU.Exception.KeyNotFound(_damageType);
	}

	function getDamageTypeInjuries ( _damageType )
	{	
		local idx = ::MSU.Math.log2int(_damageType) + 1;
		if (idx == idx.tointeger() && idx < this.DamageTypeInjuries.len())
		{
			return this.DamageTypeInjuries[idx].Injuries;
		}
		throw ::MSU.Exception.KeyNotFound(_damageType);
	}

	function setDamageTypeInjuries ( _damageType, _injuriesOnHead, _injuriesOnBody )
	{
		local injuries = this.getDamageTypeInjuries(_damageType);

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
				injuries = clone (_bodyPart == ::Const.BodyPart.Head ? inj.Head : inj.Body);
				break;
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

::Const.Damage.DamageType <- {
		None = 0,
		Blunt = 1,
		Piercing = 2
		Cutting = 4,
		Burning = 8
};

::Const.Damage.DamageTypeName <- [
	"No Damage Type",
	"Blunt",
	"Piercing",
	"Cutting",
	"Burning"
];

::Const.Damage.DamageTypeInjuries <- [
	{
		DamageType = ::Const.Damage.DamageType.None,
		Injuries = {
			Head = [],
			Body = []
		}
	},
	{
		DamageType = ::Const.Damage.DamageType.Blunt,
		Injuries = {
			Head = ::Const.Injury.BluntHead,
			Body = ::Const.Injury.BluntBody
		}
	},
	{
		DamageType = ::Const.Damage.DamageType.Piercing,
		Injuries = {
			Head = ::Const.Injury.PiercingHead,
			Body = ::Const.Injury.PiercingBody
		}
	},
	{
		DamageType = ::Const.Damage.DamageType.Cutting,
		Injuries = {
			Head = ::Const.Injury.CuttingHead,
			Body = ::Const.Injury.CuttingBody
		}
	},
	{
		DamageType = ::Const.Damage.DamageType.Burning,
		Injuries = {
			Head = ::Const.Injury.BurningHead,
			Body = ::Const.Injury.BurningBody
		}
	}
];
