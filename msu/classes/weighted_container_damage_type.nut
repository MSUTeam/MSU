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
					local blunt = ::Const.Injury.BluntBody.len() + ::Const.Injury.BluntHead.len();
					local piercing = ::Const.Injury.PiercingBody.len() + ::Const.Injury.PiercingHead.len();
					local total = (blunt + piercing).tofloat();
					this.add(::Const.Damage.DamageType.Blunt, ::MSU.Math.roundToMult(100 * blunt / total, 5)); // We round to the nearest multiple of 5 to make it "cleaner" for players
					this.add(::Const.Damage.DamageType.Piercing, ::MSU.Math.roundToMult(100 * piercing / total, 5));
					break;

				case ::Const.Injury.BurningAndPiercingBody:
					local burning = ::Const.Injury.BurningBody.len() + ::Const.Injury.BurningHead.len();
					local piercing = ::Const.Injury.PiercingBody.len() + ::Const.Injury.PiercingHead.len();
					local total = (burning + piercing).tofloat();
					this.add(::Const.Damage.DamageType.Burning, ::MSU.Math.roundToMult(100 * burning / total, 5));
					this.add(::Const.Damage.DamageType.Piercing, ::MSU.Math.roundToMult(100 * piercing / total, 5));
					break;

				case ::Const.Injury.CuttingAndPiercingBody:
					local cutting = ::Const.Injury.CuttingBody.len() + ::Const.Injury.CuttingHead.len();
					local piercing = ::Const.Injury.PiercingBody.len() + ::Const.Injury.PiercingHead.len();
					local total = (cutting + piercing).tofloat();
					this.add(::Const.Damage.DamageType.Cutting, ::MSU.Math.roundToMult(100 * cutting / total, 5));
					this.add(::Const.Damage.DamageType.Piercing, ::MSU.Math.roundToMult(100 * piercing / total, 5));
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

	foreach (p in info.defparams)
	{
		local t = typeof p;
		if (t == "array" || t == "table" || t == "instance" || t == "class")
		{
			::logError(format("WeightedContainer and its parent classes cannot have a function with reference type parameters -- function %s has a parameter with type %s", k, t));
			throw ::MSU.Exception.InvalidValue(t);
		}
	}

	local declarationParams = clone info.parameters; // used in compilestring for function declaration
	local wrappedParams = clone declarationParams; // used in compilestring to call base function

	if (declarationParams[declarationParams.len() - 1] == "...")
	{
		declarationParams.remove(declarationParams.len() - 2); // remove "vargv"
		wrappedParams.remove(wrappedParams.len() - 1); // remove "..."
	}
	else // function with vargv cannot have defparams
	{
		foreach (i, defparam in info.defparams)
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
