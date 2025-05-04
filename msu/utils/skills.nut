local scheduleEvent = ::Time.scheduleEvent;
::Time.scheduleEvent = function( _timeUnit, _time, _func, _data )
{
	local caller = ::getstackinfos(2).locals["this"];
	if (!::isKindOf(caller, "skill") || !(caller in ::MSU.Skills.ScheduleSkills))
	{
		scheduleEvent(_timeUnit, _time, _func, _data);
		return;
	}

	::MSU.Skills.ScheduleSkills[caller].Count++;

	local function foo( _arg1 )
	{
		if (_func != null)
			_func(_arg1);
		::MSU.Skills.ScheduleSkills[caller].onScheduleComplete();
	}

	scheduleEvent(_timeUnit, _time, foo, _data);
}

local teleport = ::TacticalNavigator.teleport;
::TacticalNavigator.teleport <- function( _user, _targetTile, _func, _data, _bool, _float = 1.0 )
{
	local caller = ::getstackinfos(2).locals["this"];
	if (!::isKindOf(caller, "skill") || !(caller in ::MSU.Skills.ScheduleSkills))
	{
		teleport(_user, _targetTile, _func, _data, _bool, _float);
		return;
	}

	::MSU.Skills.ScheduleSkills[caller].Count++;

	local function foo( _arg1, _arg2 )
	{
		if (_func != null)
			_func(_arg1, _arg2);
		::MSU.Skills.ScheduleSkills[caller].onScheduleComplete();
	}

	teleport(_user, _targetTile, foo, _data, _bool, _float);
}

local switchEntities = ::TacticalNavigator.teleport;
::TacticalNavigator.switchEntities <- function( _user, _targetEntity, _func, _data, _float )
{
	local caller = ::getstackinfos(2).locals["this"];
	if (!::isKindOf(caller, "skill") || !(caller in ::MSU.Skills.ScheduleSkills))
	{
		switchEntities(_user, _targetEntity, _func, _data, _float);
		return;
	}

	::MSU.Skills.ScheduleSkills[caller].Count++;

	local function foo( _arg1, _arg2 )
	{
		if (_func != null)
			_func(_arg1, _arg2);
		::MSU.Skills.ScheduleSkills[caller].onScheduleComplete();
	}

	switchEntities(_user, _targetEntity, foo, _data, _float);
}

::MSU.Skills <- {
	PreviewApplicableFunctions = [
		"getActionPointCost",
		"getFatigueCost"
	],
	QueuedPreviewChanges = {},
	SoftResetFields = [
		"ActionPointCost",
		"FatigueCost",
		"FatigueCostMult",
		"MinRange",
		"MaxRange"
	],
	ScheduleSkills = {},

	ScheduleSkill = class {
		Skill = null;
		Container = null;
		TargetTile = null;
		TargetEntity = null;
		ForFree = false;
		Count = 0;

		constructor( _skill, _targetTile, _targetEntity, _forFree )
		{
			::logInfo("Creating ScheduleSkill for " + _skill.getID());
			this.Skill = _skill;
			this.Container = _skill.getContainer();
			this.TargetTile = _targetTile;
			this.TargetEntity = _targetEntity;
			this.ForFree = _forFree;
		}

		function onScheduleComplete()
		{
			::logInfo("onScheduleComplete " + this.Skill.getID());
			if (--this.Count == 0)
			{
				::logInfo("All schedules complete");
				if (!::MSU.isNull(this.Container))
					this.Container.onAnySkillExecutedFully(this.Skill, this.TargetTile, this.TargetEntity, this.ForFree);
				delete ::MSU.Skills.ScheduleSkills[this.Skill];
			}
		}
	}

	function addEvent( _name, _function = null, _update = true, _aliveOnly = false )
	{
		::MSU.MH.hook("scripts/skills/skill", function(q) {
			q[_name] <- _function == null ? function() {} : _function;
		});

		::MSU.MH.hook("scripts/skills/skill_container", function(q) {
			if (_function == null || _function.getinfos().parameters.len() == 1) // for parameterless functions it should be a len 1 array containing "this"
			{
				q[_name] <- @() this.callSkillsFunction(_name, null, _update, _aliveOnly);
			}
			else
			{
				local info = _function.getinfos();
				foreach (p in info.defparams)
				{
					local t = typeof p;
					if (t == "array" || t == "table" || t == "instance" || t == "class")
					{
						::logError("addEvent: _function params cannot have mutable default values");
						throw ::MSU.Exception.InvalidValue(t);
					}
				}
				local declarationParams = clone info.parameters; // used in compilestring for function declaration
				declarationParams.remove(0) // remove "this"
				local wrappedParams = clone declarationParams; // used in compilestring to call skills function

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

				q[_name] <- compilestring(format("return function (%s) { return this.callSkillsFunction(\"%s\", [%s], %s, %s); }", declarationParams.reduce(@(a, b) a + ", " + b), _name, wrappedParams.reduce(@(a, b) a + ", " + b), _update + "", _aliveOnly + ""))();
			}
		});
	}

	function addPreviewApplicableFunction( _name )
	{
		::MSU.requireString(_name);
		if (this.PreviewApplicableFunctions.find(_name) == null) this.PreviewApplicableFunctions.push(_name);
	}

	function addToSoftReset( _field )
	{
		if (this.SoftResetFields.find(_field) == null) this.SoftResetFields.push(_field);
	}

	function removeFromSoftReset( _field )
	{
		local idx = this.SoftResetFields.find(_field);
		if (idx != null) this.SoftResetFields.remove(idx);
	}

	// Private
	function modifyPreview( _caller, _targetSkill, _field, _newChange, _multiplicative )
	{
		if (!(_caller in this.QueuedPreviewChanges)) this.QueuedPreviewChanges[_caller] <- [];
		this.QueuedPreviewChanges[_caller].push({
			TargetSkill = _targetSkill,
			Field = _field,
			ValueBefore = 0,
			CurrChange = _multiplicative ? 1 : 0,
			NewChange = _newChange,
			Multiplicative = _multiplicative
		});
	}
}
