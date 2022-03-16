this.MSU.Class.SettingsElement <- class
{
	Name = null;
	ID = null;
	static Type = "Element";
	Flags = null;
	Description = null;
	Parent = null;

	constructor(_id, _name = null)
	{
		if (_id.find(" ") != null)
		{
			this.logError("The ID of a Setting Element should not have spaces");
			throw ::MSU.Exception.InvalidType;
		}
		this.Name = _name == null ? _id : _name;
		this.ID = _id;
		this.Flags = [];
		this.Description = "";
	}

	function getType()
	{
		return this.Type;
	}

	function setParent( _parent )
	{
		this.Parent = _parent.weakref();
	}

	function getParent()
	{
		return this.Parent;
	}

	function getPanelID()
	{
		return this.getParent().getParent().getID();
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

	function addFlags( ... )
	{
		this.Flags.extend(vargv);
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
					if (this.Flags.find(required) == null)
					{
						return false;
					}
				}
			}
			if ("excluded" in _flags)
			{
				foreach (excluded in _flags.excluded)
				{
					if (this.Flags.find(excluded) != null)
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
		return {
			type = this.getType(),
			id = this.getID(),
			name = this.getName()
		};
	}
}
