::MSU.MH.hook("scripts/skills/backgrounds/character_background", function(q) {
	q.onBackgroundChanged <- function( _oldBackground )
	{
	}
});

::MSU.QueueBucket.VeryLate.push(function() {
	::MSU.MH.hookTree("scripts/skills/backgrounds/character_background", function(q) {
		q.onAdded = @(__original) function()
		{
			if (this.m.IsNew)
			{
				__original();
				this.onBackgroundChanged(this.getContainer().getActor().m.MSU_OldBackground);
				this.getContainer().getActor().m.MSU_OldBackground = null;
			}
			else
			{
				__original();
			}
		}

		q.onRemoved = @(__original) function()
		{
			__original();
			this.getContainer().getActor().m.MSU_OldBackground = this;
		}
	});
});
