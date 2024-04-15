::MSU.HooksHelper <- {
	function addBaseItemToNamedItem( _script )
	{
		::MSU.HooksMod.hook(_script, function(q) {
			q.m.BaseItemScript <- null;
			q.m.BaseItemFields <- [];
		});

		::MSU.QueueBucket.VeryLate.push(function() {
			::MSU.HooksMod.hook(_script, function(q) {
				q.randomizeValues = @(__original) function()
				{
					if (this.m.BaseItemScript != null)
					{
						local baseM = ::new(this.m.BaseItemScript).m;
						foreach (field in this.m.BaseItemFields)
						{
							this.m[field] = baseM[field];
						}
					}

					return __original();
				}
			});
		});
	}
}
