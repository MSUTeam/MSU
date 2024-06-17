this.msu_tactical_dependency_skill <- ::inherit("scripts/skills/skill", {
	m = {
		SkillsToAdd = [],
		SkillsAdded = [],
		AppliesToSelf = true
	},
	function create()
	{
		this.m.ID = "special.msu_tactical_dependency";
		this.m.Type = ::Const.SkillType.Special;
	}

	// We have a hook on this skill in msu/hooks/skills/special/msu_tactical_dependency.nut
	// to wrap some functions

	function onSpawnEntity( _entity )
	{
		// I spawned
		if (_entity.getID() == this.getContainer().getActor().getID())
		{
			foreach (faction in ::Tactical.Entities.getAllInstances)
			{
				foreach (receiver in faction)
				{
					if (!this.validateReceiver(receiver) || (!this.m.AppliesToSelf && receiver.getID() == _entity.getID()))
						continue;

					foreach (script in this.m.SkillsToAdd)
					{
						this.addSkillToReceiver(receiver, ::new(script));
					}
				}
			}
		}
		// someone else spawned
		else if (this.validateReceiver(_entity))
		{
			foreach (script in this.m.SkillsToAdd)
			{
				this.addSkillToReceiver(receiver, ::new(script));
			}
		}
	}

	// Add conditions to filter which kinds of entities receive the dependencies e.g. check faction, allied status etc.
	function validateReceiver( _entity )
	{
		return true;
	}

	function onAddedSkillToReceiver( _entity, _skillAdded )
	{
	}

	function isEnabled()
	{
		return true;
	}

	function addSkillToReceiver( _receiver, _skill )
	{
		_receiver.getSkills().add(_skill);
		_receiver.getSkills().update(); // Just in case the receiver already had the skill and only a onRefresh() occurred
		_skill = _receiver.getSkills().getSkillByID(_skill.getID()); // Get the skill by ID again due to stack based skills
		if (_skill != null)
		{
			this.m.SkillsAdded.push(::MSU.asWeakTableRef(_skill));
			this.onAddedSkillToReceiver(_receiver, _skill);
		}
	}

	function removeAllAddedSkills( _update = true )
	{
		foreach (skill in this.m.SkillsAdded)
		{
			if (::MSU.isNull(skill) || ::MSU.isNull(skill.getContainer()))
				continue;

			skill.removeSelf();
			if (_update) skill.getContainer().update();
		}
	}
});
