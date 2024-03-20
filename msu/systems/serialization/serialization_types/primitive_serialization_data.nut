::MSU.Class.PrimitiveData <- class extends ::MSU.Class.AbstractData
{
	constructor( _type, _data )
	{
		switch( _type )
		{
			case ::MSU.Utils.SerializationDataType.U8:
				::MSU.requireInt(_data);
				if (_data < 0 || _data > 255)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Utils.SerializationDataType.U16:
				::MSU.requireInt(_data);
				if (_data < 0 || _data > 65535)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Utils.SerializationDataType.U32:
				::MSU.requireInt(_data);
				if (_data < 0)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Utils.SerializationDataType.I8:
				::MSU.requireInt(_data);
				if (_data < -128 || _data > 127)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Utils.SerializationDataType.I16:
				::MSU.requireInt(_data);
				if (_data < -32768 || _data > 32767)
					throw ::MSU.Exception.InvalidValue(_data);
				break;

			case ::MSU.Utils.SerializationDataType.I32:
				::MSU.requireInt(_data);
				break;

			case ::MSU.Utils.SerializationDataType.F32:
				::MSU.requireFloat(_data);
				break;

			case ::MSU.Utils.SerializationDataType.Bool:
				::MSU.requireBool(_data);
				break;

			case ::MSU.Utils.SerializationDataType.String:
				::MSU.requireString(_data);
				break;

			case ::MSU.Utils.SerializationDataType.Null:
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
		if (this.getType() != ::MSU.Utils.SerializationDataType.Null)
			_out["write" + ::MSU.Utils.SerializationDataType.getKeyForValue(this.getType())](this.getData());
	}

	function deserialize( _in )
	{
		if (this.getType() != ::MSU.Utils.SerializationDataType.Null)
			this.__Data = _in["read" + ::MSU.Utils.SerializationDataType.getKeyForValue(this.getType())]();
	}
}
