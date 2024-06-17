::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.MH.hookTree("scripts/skills/special/msu_aura_source", function(q) {
		q.onDeath = @(__original) function( _fatalityType )
		{
			__original(_fatalityType);
			this.unregisterFromAllReceivers();
		}

		q.onRemoved = @(__original) function()
		{
			__original();
			this.unregisterFromAllReceivers();
		}

		q.onMovementFinished = @(__original) function( _tile )
		{
			__original(_tile);
			if (!this.isGarbage()) this.triggerUpdateForReceivers(false);
		}
	});
});
