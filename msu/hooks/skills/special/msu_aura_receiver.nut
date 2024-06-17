::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.MH.hookTree("scripts/skills/special/msu_aura_receiver", function(q) {
		q.onDeath = @(__original) function( _fatalityType )
		{
			__original(_fatalityType);
			this.unregisterFromAllSources();
		}

		q.onRemoved = @(__original) function()
		{
			__original();
			this.unregisterFromAllSources();
		}

		q.onMovementFinished = @(__original) function( _tile )
		{
			__original(_tile);
			if (!this.isGarbage()) this.setAuraProviders();
		}
	});
});
