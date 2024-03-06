::MSU.Class.SerializationDataContainer <- class
{
	static __Type = ::MSU.Utils.SerializationDataType.None;
	__Data = null; // actual data
	__SerializationData = null; // an array that contains the data in the form of instances of SerializationDataContainer i.e. an intermediary state
	static DataType = ::MSU.Utils.SerializationDataType;

	constructor( _type, _data )
	{
		this.__Type = _type;
		this.__Data = _data;
		switch (_type)
		{
			case this.DataType.Array:
			case this.DataType.SerializationData:
				this.__SerializationData = array(_data.len());
				foreach (i, item in _data)
				{
					this.__SerializationData[i] = this.__convertValueFromBaseType(item);
				}
				break;

			 case this.DataType.Table:
			 	this.__SerializationData = array(_data.len() * 2);
			 	foreach (key, value in _data)
			 	{
			 		this.__SerializationData[i] = this.__convertValueFromBaseType(key);
			 		this.__SerializationData[i] = this.__convertValueFromBaseType(value);
			 	}
			 	break;

			 default:
			 	this.__SerializationData = [this.__convertValueFromBaseType(_data)];
		}
	}

	function getType()
	{
		return this.__Type;
	}

	function getData()
	{
		return this.getType() == this.DataType.SerializationData ? this : this.__Data;
	}

	function len()
	{
		return this.__Data.len();
	}

	function pushElement( _data )
	{
		if (this.getType() != this.DataType.SerializationData)
			throw "can only add data if the container contains SerializationData";

		this.__SerializationData.push(_data);
	}

	function getElement( _idx )
	{
		return this.__SerializationData[_idx];
	}

	function serialize( _out )
	{
		_out.writeU8(this.getType());

		switch (this.getType())
		{
			case this.DataType.Array:
			case this.DataType.SerializationData:
			case this.DataType.Table:
				_out.writeU32(this.__SerializationData.len());
				foreach (item in this.__SerializationData)
				{
					item.serialize();
				}
				break;

			default:
				_out["write" + this.DataType.getKeyForValue(this.getType())](this.getData());
		}
	}

	function deserialize( _in )
	{
		local type = _in.readU8();
		switch (type)
		{
			case this.DataType.Array:
			case this.DataType.SerializationData: // aka an instance of our pseudo-new data type SerializationDataContainer
				local len = _in.readU32();
				this.__SerializationData = array(len);
				this.__Data = array(len);
				for (local i = 0; i < len; i++)
				{
					this.__SerializationData[i] = this.__readValueFromStorage(_in);
					this.__Data[i] = this.__SerializationData[i].getData();
				}
				break;

			case this.DataType.Table:
				local len = _in.readU32();
				this.__SerializationData = array(len);
				this.__Data = {};
				for (local i = 0; i < len; i+=2)
				{
					local key = this.__readValueFromStorage(_in);
					local value = this.__readValueFromStorage(_in);
					this.__SerializationData[i] = key;
					this.__SerializationData[i+1] = value;
					this.__Data[key.getData()] <- value.getData();
				}
				break;

			default:
				this.__Data = _in["read" + this.DataType.getKeyForValue(type)]();
				this.__SerializationData = [this.__convertValueFromBaseType(this.__Data)];
		}
	}

	function __readValueFromStorage( _in )
	{
		local type = _in.readU8();
		switch (type)
		{
			case this.DataType.Table:
				local ret = ::MSU.Class.SerializationDataContainer(type, {});
				ret.deserialize(_in);
				return ret;

			case this.DataType.Array:
			case this.DataType.SerializationData: // aka an instance of our pseudo-new data type SerializationDataContainer
				local ret = ::MSU.Class.SerializationDataContainer(type, []);
				ret.deserialize(_in);
				return ret;

			default:
				return ::MSU.Class.SerializationDataContainer(type, _in["read" + this.DataType.getKeyForValue(type)]());
		}
	}

	function __convertValueFromBaseType( _value )
	{
		switch (typeof _value)
		{
			case "integer":
				if (_value >= 0)
				{
					if (_value <= 255)
						return ::MSU.Class.SerializationDataContainer(this.DataType.U8, _value);
					else if (_value <= 65535)
						return ::MSU.Class.SerializationDataContainer(this.DataType.U16, _value);
					else
						return ::MSU.Class.SerializationDataContainer(this.DataType.U32, _value);
				}
				else
				{
					if (_value >= -128)
						return ::MSU.Class.SerializationDataContainer(this.DataType.I8, _value);
					else if  (_value >= -32768)
						return ::MSU.Class.SerializationDataContainer(this.DataType.I16, _value);
					else
						return ::MSU.Class.SerializationDataContainer(this.DataType.I32, _value);
				}
				break;
			case "string":
				return ::MSU.Class.SerializationDataContainer(this.DataType.String, _value);
			case "float":
				return ::MSU.Class.SerializationDataContainer(this.DataType.F32, _value);
			case "bool":
				return ::MSU.Class.SerializationDataContainer(this.DataType.Bool, _value);
			case "null":
				return ::MSU.Class.SerializationDataContainer(this.DataType.Null, null);
			case "table":
				if (::MSU.isBBObject(_value))
				{
					::logError("MSU Serialization cannot serialize BB Objects directly");
					throw ::MSU.Exception.InvalidValue(_value);
				}
				return ::MSU.Class.SerializationDataContainer(this.DataType.Table, _value);
			case "array":
				return ::MSU.Class.SerializationDataContainer(this.DataType.Array, _value);
			case "instance":
				if (_value instanceof ::MSU.Class.SerializationDataContainer)
					return _value;

				// TODO:
				// if (_value instanceof ::MSU.Class.StrictSerDeEmulator)
				// 	return _value.getDataArray();
				// ::logError("MSU Serialization cannot handle instances other than descendants of ::MSU.Class.AbstractSerializationData");
				throw ::MSU.Exception.InvalidValue(_value);
			default:
				::logError("Attempted to serialize unknown type");
				throw ::MSU.Exception.InvalidType(_value);
		}
	}
}
