this.msu_aura_receiver <- ::inherit("scripts/skills/skill", {
	m = {
		AuraSources = [], // Array of msu_aura_source skills in battle who can potentially provide this aura
		AuraProviders = [] // Array of msu_aura_source skills who currently provide this aura to me
	},
	function create()
	{
		this.m.ID = "special.msu_aura_receiver";
		this.m.Type = ::Const.SkillType.Special;
		this.m.IsRemovedAfterBattle = true;
	}

	// We have a hook on this skill in msu/hooks/skills/special/msu_aura_receiver.nut
	// to wrap some functions

	function isHidden()
	{
		return this.m.AuraProviders.len() == 0;
	}

	function getAuraProviders()
	{
		return this.m.AuraProviders;
	}

	function getAuraProvider()
	{
		return this.m.AuraProviders.len() == 0 ? null : this.m.AuraProviders[0];
	}

	function registerAuraSource( _skill )
	{
		foreach (source in this.m.AuraSources)
		{
			if (::MSU.isEqual(source, _skill))
				return;
		}

		this.m.AuraSources.push(::MSU.asWeakTableRef(_skill));

		this.setAuraProviders();
	}

	function unregisterAuraSource( _skill )
	{
		foreach (i, source in this.m.AuraSources)
		{
			if (::MSU.isEqual(source, _skill))
			{
				this.m.AuraSources.remove(i);
				break;
			}
		}

		this.setAuraProviders();
	}

	function unregisterFromAllSources()
	{
		local actor = this.getContainer().getActor();
		foreach (source in this.m.AuraSources)
		{
			source.unregisterAuraReceiver(this);
		}
	}

	function setAuraProviders()
	{
		this.m.AuraProviders.clear();

		foreach (source in this.m.AuraSources)
		{
			local sourceActor = source.getContainer().getActor();
			if (!sourceActor.isPlacedOnMap())
				continue;

			if (source.isEnabled() && sourceActor.getTile().getDistanceTo(this.getContainer().getActor().getTile()) <= source.getAuraRange())
			{
				this.m.AuraProviders.push(::MSU.asWeakTableRef(source));
			}
		}
	}
});
