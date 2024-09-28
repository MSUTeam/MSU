::MSU.MH.hook("scripts/entity/tactical/entity", function(q) {
	q.m.UID <- 0;

	q.create <- @(__original) function()
	{
		__original();
		this.m.UID = ::MSU.Utils.generateUID();
	}

	q.getUID <- function()
	{
		return this.m.UID;
	}

	q.onSerialize = @(__original) function( _out )
	{
		this.m.Flags.set("MSU_UID", this.m.UID);
		__original(_out);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		if (this.getFlags().has("MSU_UID"))
		{
			this.m.UID = this.getFlags().get("MSU_UID");
			this.getFlags().remove("MSU_UID");
		}
		else
		{
			this.m.UID = ::MSU.Utils.generateUID();
		}
	}
});
