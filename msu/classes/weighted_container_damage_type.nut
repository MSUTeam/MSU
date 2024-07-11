::MSU.Class.DamageType <- class extends ::MSU.Class.WeightedContainer
{
	__Skill = null;
	__IsInitDone = true;

	function setSkill( _skill )
	{
		this.__Skill = ::MSU.asWeakTableRef(_skill);
		this.__IsInitDone = false;
	}

	function doInit()
	{
		if (this.__IsInitDone || ::MSU.isNull(this.__Skill))
			return;

		this.__IsInitDone = true;

		if (this.__Skill.m.IsAttack && this.len() == 0)
		{
			switch (this.__Skill.m.InjuriesOnBody)
			{
				case null:
					this.add(::Const.Damage.DamageType.None);
					break;

				case ::Const.Injury.BluntBody:
					this.add(::Const.Damage.DamageType.Blunt);
					break;

				case ::Const.Injury.PiercingBody:
					this.add(::Const.Damage.DamageType.Piercing);
					break;

				case ::Const.Injury.CuttingBody:
					this.add(::Const.Damage.DamageType.Cutting);
					break;

				case ::Const.Injury.BurningBody:
					this.add(::Const.Damage.DamageType.Burning);
					break;

				case ::Const.Injury.BluntAndPiercingBody:
					this.add(::Const.Damage.DamageType.Blunt, 55);
					this.add(::Const.Damage.DamageType.Piercing, 45);
					break;

				case ::Const.Injury.BurningAndPiercingBody:
					this.add(::Const.Damage.DamageType.Burning, 25);
					this.add(::Const.Damage.DamageType.Piercing, 75);
					break;

				case ::Const.Injury.CuttingAndPiercingBody:
					this.add(::Const.Damage.DamageType.Cutting);
					this.add(::Const.Damage.DamageType.Piercing);
					break;

				default:
					this.add(::Const.Damage.DamageType.Unknown);
			}
		}
	}
}

foreach (k, v in ::MSU.Class.WeightedContainer)
{
	if (typeof v != "function")
		continue;

	local info = v.getinfos();
	local declarationParams = clone info.parameters; // used in compilestring for function declaration
	local wrappedParams = clone declarationParams; // used in compilestring to call skills function

	if (declarationParams[declarationParams.len() - 1] == "...")
	{
		declarationParams.remove(declarationParams.len() - 2); // remove "vargv"
		wrappedParams.remove(wrappedParams.len() - 1); // remove "..."
	}
	else // function with vargv cannot have defparams
	{
		foreach (i, defparam in info.defparams) // We don't add handling for ref-type defparams. We expect our parent classes to not have such functions.
		{
			if (defparam == null)
				defparam = "null";

			declarationParams[declarationParams.len() - info.defparams.len() + i] += " = " + defparam;
		}
	}

	declarationParams.remove(0); // remove "this"
	wrappedParams.remove(0); // remove "this"
	declarationParams = declarationParams.len() == 0 ? "" : declarationParams.reduce(@(a, b) a + ", " + b);
	wrappedParams = wrappedParams.len() == 0 ? "" : wrappedParams.reduce(@(a, b) a + ", " + b);

	::MSU.Class.DamageType[k] <- compilestring(format("return function (%s) { this.doInit(); return base.%s(%s); }", declarationParams, k, wrappedParams))();
}
