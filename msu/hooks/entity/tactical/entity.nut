::MSU.MH.hook("scripts/entity/tactical/entity", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.MSU_generateUID();
	}

	q.getUID <- function()
	{
		if (::MSU.Serialization.isLoading())
			throw "trying to get UID during deserialization";

		return this.getFlags().get("MSU_UID");
	}

	// Private
	q.MSU_generateUID <- function( _force = false )
	{
		if (_force)
		{
			this.getFlags().set("MSU_UID", ::MSU.Utils.__generateUID());
		}
		else
		{
			this.getFlags().set("MSU_UID", ::MSU.Serialization.isLoading() ? null : ::MSU.Utils.__generateUID());
		}
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		if (this.getFlags().get("MSU_UID") == null)
		{
			this.MSU_generateUID(true);
		}
	}
});
