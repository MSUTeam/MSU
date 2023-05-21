::MSU.Class.CustomSerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	__MetaData = null;

	constructor(_data, _metaData)
	{
		this.__MetaData = _metaData;
		base.constructor(_data);
	}

	function getMetaData()
	{
		return this.__MetaData;
	}

	function setMetaData( _metaData )
	{
		this.__MetaData = _metaData;
	}

	// must be called when overriden
	function deserialize( _in )
	{
		local type = _in.readU8();
		if (type != this.DataType.U32)
			throw ::MSU.Exception.InvalidValue(type);
		this.setLength(_in.readU32());
	}

	// must be called when overriden
	function serialize( _out )
	{
		_out.writeU8(this.getType());
		_out.writeString(this.getMetaData());
		::MSU.Class.U32SerializationData(this.len()).serialize(_out); // store length
	}

	function setLength( _length )
	{
		throw "TODO" // must be implemented for all containers inheriting from this object
	}

	function len()
	{
		throw "TODO" // must be implemented for all containers inheriting from this object
	}

	function __readValueFromStorage( _in )
	{
		local type = _in.readU8();
		switch (type)
		{
			case this.DataType.Null:
				return ::MSU.Class.NullSerializationData();
			case this.DataType.Bool:
				return ::MSU.Class.BoolSerializationData(_in.readBool());
			case this.DataType.String:
				return ::MSU.Class.StringSerializationData(_in.readString());
			case this.DataType.U8:
				return ::MSU.Class.U8SerializationData(_in.readU8());
			case this.DataType.U16:
				return ::MSU.Class.U16SerializationData(_in.readU16());
			case this.DataType.U32:
				return ::MSU.Class.U32SerializationData(_in.readU32());
			case this.DataType.I8:
				return ::MSU.Class.I8SerializationData(_in.readI8());
			case this.DataType.I16:
				return ::MSU.Class.I16SerializationData(_in.readI16());
			case this.DataType.I32:
				return ::MSU.Class.I32SerializationData(_in.readI32());
			case this.DataType.F32:
				return ::MSU.Class.F32SerializationData(_in.readF32());
			case this.DataType.DataArray:
				local dataArray = ::MSU.Class.DataArrayData(_in.readString());
				dataArray.deserialize(_in);
				return dataArray;
			case this.DataType.Table:
				local table = ::MSU.Class.TableSerializationData(null, _in.readString());
				table.deserialize(_in);
				return table;
			case this.DataType.Array:
				local array = ::MSU.Class.ArraySerializationData(null, _in.readString());
				array.deserialize(_in);
				return array;
			default:
				local unknownData =  ::MSU.Class.UnknownSerializationData(type, _in.readString());
				unknownData.deserialize(_in);
				return unknownData;
		}
	}

	function __convertValueFromBaseType( _value )
	{
		local type = typeof _value;
		switch (type)
		{
			case "integer":
				if (_value >= 0)
				{
					if (_value <= 255)
					{
						return ::MSU.Class.U8SerializationData(_value);
					}
					else if (_value <= 65535)
					{
						return ::MSU.Class.U16SerializationData(_value);
					}
					else
					{
						return ::MSU.Class.U32SerializationData(_value);
					}
				}
				else
				{
					if (_value >= -128)
					{
						return ::MSU.Class.I8SerializationData(_value);
					}
					else if  (_value >= -32768)
					{
						return ::MSU.Class.I16SerializationData(_value);
					}
					else
					{
						return ::MSU.Class.I32SerializationData(_value);
					}
				}
				break;
			case "string":
				return ::MSU.Class.StringSerializationData(_value);
			case "float":
				return ::MSU.Class.F32SerializationData(_value);
			case "bool":
				return ::MSU.Class.BoolSerializationData(_value);
			case "null":
				return ::MSU.Class.NullSerializationData();
			case "table":
				if (::MSU.isBBObject(_value))
				{
					::logError("MSU Serialization cannot handle BB Objects");
					throw ::MSU.Exception.InvalidValue(_value);
				}
				return ::MSU.Class.TableSerializationData(_value, "table");
			case "array":
				return ::MSU.Class.ArraySerializationData(_value, "array");
			case "instance":
				if (_value instanceof ::MSU.Class.AbstractSerializationData)
					return _value;
				if (_value instanceof ::MSU.Class.StrictSerDeEmulator)
					return _value.getDataArray();
				::logError("MSU Serialization cannot handle instances other than descendants of ::MSU.Class.AbstractSerializationData");
				throw ::MSU.Exception.InvalidValue(_value);
			default:
				::logError("Attempted to serialize unknown type");
				throw ::MSU.Exception.InvalidType(_value);
		}
	}
}

