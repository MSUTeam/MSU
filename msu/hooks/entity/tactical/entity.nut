::MSU.MH.hook("scripts/entity/tactical/entity", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.getFlags().set("MSU_UID", ::MSU.Serialization.isLoading() ? null : ::MSU.Utils.__generateUID());
	}

	q.getUID <- function()
	{
		if (::MSU.Serialization.isLoading())
			throw "trying to get UID during deserialization";

		return this.getFlags().get("MSU_UID");
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		if (this.getFlags().get("MSU_UID") == null)
		{
			this.getFlags().set("MSU_UID", ::MSU.Utils.__generateUID());
		}
	}
});
