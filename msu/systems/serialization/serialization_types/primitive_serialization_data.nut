::MSU.Class.PrimitiveData <- class extends ::MSU.Class.AbstractData
{
	constructor( _type, _data )
	{
		switch( _type )
		{
			case ::MSU.Serialization.DataType.U8:
				::MSU.requireOneFromTypes(["integer", "bool"], _data);
				if (_data < 0 || _data > 255)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.U16:
				::MSU.requireOneFromTypes(["integer", "bool"], _data);
				if (_data < 0 || _data > 65535)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.U32:
				::MSU.requireOneFromTypes(["integer", "bool"], _data);
				if (_data < 0)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.I8:
				::MSU.requireOneFromTypes(["integer", "bool"], _data);
				if (_data < -128 || _data > 127)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.I16:
				::MSU.requireOneFromTypes(["integer", "bool"], _data);
				if (_data < -32768 || _data > 32767)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.I32:
				::MSU.requireOneFromTypes(["integer", "bool"], _data);
				break;

			case ::MSU.Serialization.DataType.F32:
				::MSU.requireOneFromTypes(["integer", "float", "bool"], _data);
				break;

			case ::MSU.Serialization.DataType.Bool:
				::MSU.requireBool(_data);
				break;

			case ::MSU.Serialization.DataType.String:
				::MSU.requireString(_data);
				break;

			case ::MSU.Serialization.DataType.Null:
				if (_data != null)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			default:
				throw ::MSU.Exception.InvalidValue(_type);
		}

		base.constructor(_type, _data);
	}

	function isTypeValid( _type )
	{
		if (base.isTypeValid(_type))
			return true;

		switch (_type)
		{
			case ::MSU.Serialization.DataType.Bool:
				return this.__Type != ::MSU.Serialization.DataType.String && this.__Type != ::MSU.Serialization.DataType.Null;

			case ::MSU.Serialization.DataType.String:
			case ::MSU.Serialization.DataType.Null:
				return false;

			default:
				return this.__Type == ::MSU.Serialization.DataType.Bool && (this.getData() == 0 || this.getData() == 1);
		}
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
}
