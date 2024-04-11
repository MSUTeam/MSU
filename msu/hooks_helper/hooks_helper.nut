::MSU.HooksHelper <- {
	function addBaseItemToNamedItem( _q )
	{
		_q.m.BaseItemScript <- null;
	}

	function addBaseItemToNamedItemVeryLate( _q )
	{
		_q.randomizeValues = @(__original) function()
		{
			if (this.m.BaseItemScript != null)
			{
				local baseM = ::new(this.m.BaseItemScript).m;
				foreach (field in this.getFieldsForRandomize())
				{
					this.m[field] = baseM[field];
				}
			}

			return __original();
		}
	}
}
