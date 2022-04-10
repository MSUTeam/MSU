::MSU.Class.SerializationSystem <- class extends ::MSU.Class.System
{
	Mods = null;
	static DataType = {
		Integer = 0,
		Float = 1,
		Boolean = 2,
		String = 3,
		Array = 4,
		Table = 5
	};

	constructor()
	{
		base.constructor(::MSU.SystemID.Serialization);
		this.Mods = [];
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		this.Mods.push(_mod);
		_mod.Serialization = ::MSU.Class.SerializationModAddon(_mod);
	}

	function serializeObject( _object, _out )
	{
		::MSU.requireOneFromTypes(["array", "table"], _object);

		local type = typeof _object;
		local isTable = type == "table";

		if (isTable) _out.writeU8(this.DataType.Table);
		else _out.writeU8(this.DataType.Array);

		_out.writeU32(_object.len());

		foreach (key, element in _object)
		{
			if (isTable) _out.writeString(key);
			local dataType = typeof element;

			switch (dataType)
			{
				case "integer":
					_out.writeU8(this.DataType.Integer);
					if (element < 0)
					{
						_out.writeBool(true);
						_out.writeI32(element);
					}
					else
					{
						_out.writeBool(false);
						_out.writeU32(element);
					}
					break;

				case "float":
					_out.writeU8(this.DataType.Float);
					_out.writeF32(element);
					break;

				case "boolean":
					_out.writeU8(this.DataType.Boolean);
					_out.writeBool(element);
					break;

				case "string":
					_out.writeU8(this.DataType.String);
					_out.writeString(element);
					break;

				case "array":
					_out.writeU8(this.DataType.Array);
					::MSU.serializeObject(element, _out);
					break;

				case "table":
					_out.writeU8(this.DataType.Table);
					::MSU.serializeObject(element, _out);
					break;

				default:
					throw ::MSU.Exception.InvalidType(element);
			}
		}
	}

	function deserializeObject( _in )
	{
		local type = _in.readU8();
		local isTable = type == this.DataType.Table;
		local size = _in.readU32();

		local ret = isTable ? {} : array(size, null);

		for (local i = 0; i < size; i++)
		{
			local key = isTable ? _in.readString() : null;
			local dataType = _in.readU8();
			local val;

			switch (dataType)
			{
				case this.DataType.Integer:
					val = _in.readBool() ? _in.readI32() : _in.readU32();
					break;

				case this.DataType.Float:
					val = _in.readF32();
					break;

				case this.DataType.Boolean:
					val = _in.readBool();
					break;

				case this.DataType.String:
					val = _in.readString();
					break;

				case this.DataType.Array:
				case this.DataType.Table:
					val = ::MSU.deserializeObject(_in);
					break;

				default:
					throw ::MSU.Exception.InvalidType(dataType);
			}

			if (isTable) ret[key] <- val;
			else ret[i] = val;
		}

		return ret;
	}
}
