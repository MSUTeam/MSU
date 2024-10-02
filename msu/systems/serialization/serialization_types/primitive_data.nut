::MSU.Class.PrimitiveData <- class extends ::MSU.Class.AbstractData
{
	constructor( _type, _data )
	{
		switch( _type )
		{
			case ::MSU.Serialization.DataType.U8:
				if (typeof _data != "integer" || _data < 0 || _data > 255)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.U16:
				if (typeof _data != "integer" || _data < 0 || _data > 65535)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.U32:
				if (typeof _data != "integer" || _data < 0)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.I8:
				if (typeof _data != "integer" || _data < -128 || _data > 127)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.I16:
				if (typeof _data != "integer" || _data < -32768 || _data > 32767)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.I32:
				if (typeof _data != "integer")
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.F32:
				if (typeof _data != "float" && typeof _data != "integer")
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.Bool:
				if (typeof _data != "bool")
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.String:
				if (typeof _data != "string")
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.Null:
				if (_data != null)
					this.__printInvalidDataError(_type, _data);
				break;

			default:
				throw ::MSU.Exception.InvalidValue(_type);
		}

		base.constructor(_type, _data);
	}

	function serialize( _out )
	{
		base.serialize(_out);
		if (this.getType() != ::MSU.Serialization.DataType.Null)
			_out["write" + ::MSU.Serialization.DataType.getKeyForValue(this.getType())](this.getData());
	}

	function deserialize( _in )
	{
		if (this.getType() != ::MSU.Serialization.DataType.Null)
			this.__Data = _in["read" + ::MSU.Serialization.DataType.getKeyForValue(this.getType())]();
	}

	function __printInvalidDataError( _type, _data )
	{
		local level = 3;
		local errorSource = "";
		local infos = ::getstackinfos(level);
		while (infos != null)
		{
			local src = infos.src;
			if (src.len() < 4 || src.slice(0, 4) != "msu/" || src.len() < 9 || src.slice(0, 9) == "msu/hooks")
			{
				errorSource = format(" (%s -> %s : %i)", infos.func == "unknown" ? "" : infos.func, src, infos.line);
				break;
			}

			infos = ::getstackinfos(++level);
		}

		::logError(format("Storing invalid or unexpected data \'%s\' (type %s) in container of type: %s%s", _data + "", typeof _data, ::MSU.Serialization.DataType.getKeyForValue(_type), errorSource));

		if (errorSource == "")
			::MSU.Log.printStackTrace();
	}
}
