::MSU.MH.hook("scripts/entity/tactical/entity", function(q) {
	q.create = @(__original) function()
	{
		__original();
		if (!::MSU.Serialization.isLoading())
		{
			this.MSU_generateUID();
		}
	}

	q.getUID <- function()
	{
		if (::MSU.Serialization.isLoading())
			throw "trying to get UID during deserialization";

		return this.getFlags().get("MSU_UID");
	}

	q.MSU_generateUID <- function()
	{
		if (this.getFlags().has("MSU_UID"))
			throw "trying to generate UID for entity that already has one";

		this.getFlags().set("MSU_UID", ::MSU.Utils.__generateUID());
		::MSU.__addToUIDMap(this);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		if (!this.getFlags().has("MSU_UID"))
		{
			this.MSU_generateUID();
		}
		else
		{
			::MSU.__addToUIDMap(this);
		}
	}
});
