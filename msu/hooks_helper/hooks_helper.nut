::MSU.HooksHelper <- {
	function addBaseItemToNamedItem( _q )
	{
		_q.m.BaseItemScript <- null;

		_q.setValuesBeforeRandomize <- function()
		{
			if (this.m.BaseItemScript == null)
				return;

			local baseM = ::new(this.m.BaseItemScript).m;
			foreach (field in this.getFieldsForRandomize())
			{
				this.m[field] = baseM[field];
			}
		}
	}

	function addBaseItemToNamedItemVeryLate( _q )
	{
		_q.randomizeValues = @(__original) function()
		{
			this.setValuesBeforeRandomize();
			return __original();
		}
	}
}
