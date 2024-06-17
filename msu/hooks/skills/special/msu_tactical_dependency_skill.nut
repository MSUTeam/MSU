::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.MH.hookTree("scripts/skills/special/msu_tactical_dependency_skill", function(q) {
		q.onAdded = @(__original) function()
		{
			__original();
			if (this.isGarbage())
				return;

			foreach (script in this.m.SkillsToAdd)
			{
				this.m.SkillsToAddIDs.push(::new(script).getID());
			}
			if (::Tactical.isActive())
				this.onSpawnEntity(this.getContainer().getActor());
		}

		q.onEntityFactionChanged = @(__original) function( _entity, _oldFaction )
		{
			__original(_entity, _oldFaction);
			if (!this.isGarbage() && ::Tactical.isActive())
				this.onSpawnEntity(_entity);
		}

		q.onRemoved = @(__original) function()
		{
			__original();
			this.removeAllAddedSkills();
		}

		q.onDeath = @(__original) function( _fatalityType )
		{
			__original(_fatalityType);
			this.removeAllAddedSkills(false);
		}
	});
});
