::MSU.Class.SettingsElement <- class
{
	Name = null;
	ID = null;
	static Type = "Element";
	Flags = null;
	Description = null;
	Page = null;

	constructor( _id, _name = null )
	{
		if (_id.find(" ") != null)
		{
			::logError("The ID of a Settings Element should not have spaces");
			throw ::MSU.Exception.InvalidValue(_id);
		}
		this.Name = _name == null ? _id : _name;
		this.ID = _id;
		this.Flags = this.new("scripts/tools/tag_collection");
		this.Flags.set("IsSetting", false);
		this.Description = "";
	}

	function getType()
	{
		return this.Type;
	}

	function setPage( _page )
	{
		this.Page = _page.weakref();
	}

	function getPage()
	{
		return this.Page;
	}

	function getPanelID()
	{
		return this.getPage().getPanelID();
	}

	function getModID()
	{
		return this.getPage().getModID();
	}

	function setDescription( _description )
	{
		this.Description = _description;
	}

	function getDescription()
	{
		return this.Description;
	}

	function getName()
	{
		return this.Name;
	}

	function getID()
	{
		return this.ID;
	}

	function getFlags()
	{
		return this.Flags;
	}

	function verifyFlags( _flags )
	{
		if (_flags != null)
		{
			if ("required" in _flags)
			{
				foreach (required in _flags.required)
				{
					if (!this.Flags.has(required))
					{
						return false;
					}
				}
			}
			if ("excluded" in _flags)
			{
				foreach (excluded in _flags.excluded)
				{
					if (this.Flags.has(excluded))
					{
						return false;
					}
				}
			}
		}
		return true;
	}

	function getUIData()
	{
		local ret = {
			type = this.getType(),
			id = this.getID(),
			name = this.getName(),
			flags = {},
		}
		foreach(_, flag in this.Flags.m)
		{
			ret.flags[flag.Key] <- flag.Value;
		}
		return ret;
	}
}
