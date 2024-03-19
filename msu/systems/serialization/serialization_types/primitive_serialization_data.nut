::MSU.Class.PrimitiveData <- class extends ::MSU.Class.AbstractData
{
	constructor( _type, _data )
	{
		switch( _type )
		{
			case ::MSU.Serialization.DataType.U8:
				::MSU.requireInt(_data);
				if (_data < 0 || _data > 255)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.U16:
				::MSU.requireInt(_data);
				if (_data < 0 || _data > 65535)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.U32:
				::MSU.requireInt(_data);
				if (_data < 0)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.I8:
				::MSU.requireInt(_data);
				if (_data < -128 || _data > 127)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.I16:
				::MSU.requireInt(_data);
				if (_data < -32768 || _data > 32767)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Serialization.DataType.I32:
				::MSU.requireInt(_data);
				break;

			case ::MSU.Serialization.DataType.F32:
				::MSU.requireFloat(_data);
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
