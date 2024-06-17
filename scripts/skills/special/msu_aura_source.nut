this.msu_aura_source <- ::inherit("scripts/skills/special/msu_tactical_dependency_skill", {
	m = {
		AuraRange = 4,
		AuraReceivers = [] // Array of msu_aura_receiver skills
	},
	function create()
	{
		this.m.ID = "special.msu_aura_source";
		this.m.Type = ::Const.SkillType.Special;
	}

	// We have a hook on this skill in msu/hooks/skills/special/msu_aura_source.nut
	// to wrap some functions

	function isHidden()
	{
		return !this.isEnabled();
	}

	function getAuraRange()
	{
		return this.m.AuraRange;
	}

	function onAddedSkillToReceiver( _skillAdded )
	{
		_skillAdded.registerAuraSource(this);
	}

	function unregisterFromAllReceivers()
	{
		foreach (receiver in this.m.SkillsAdded)
		{
			receiver.unregisterAuraSource(this);
		}
	}

	function isEnabledForReceiver( _skill )
	{
		return true;
	}

	function triggerUpdateForReceivers( _updateSelf = true )
	{
		local actor = this.getContainer().getActor();
		foreach (receiver in this.m.SkillsAdded)
		{
			local receivingActor = receiver.getContainer().getActor();
			if (!_updateSelf && receivingActor.getID() == actor.getID())
				continue;

			receiver.setAuraProviders();

			if (receivingActor.isPlacedOnMap() && this.isEnabledForReceiver(receiver) && receivingActor.getTile().getDistanceTo(actor.getTile()) <= this.getAuraRange())
			{
				receivingActor.getSkills().update();
			}
		}
	}
});
