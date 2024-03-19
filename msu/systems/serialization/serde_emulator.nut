// Base for the Serialization and Deserialization Emulators
::MSU.Class.SerDeEmulator <- class
{
	MetaData = null;
	SerializationData = null;
	Idx = -1;

	constructor( _metaDataEmulator, _serializationData = null )
	{
		this.MetaData = _metaDataEmulator;
		if (_serializationData == null)
			this.resetData();
		else
		{
			::MSU.requireInstanceOf(::MSU.Class.SerializationData, _serializationData);
			this.SerializationData = _serializationData;
		}
	}

	function resetData()
	{
		this.SerializationData = ::MSU.Class.SerializationData();
	}

	function getData()
	{
		return this.SerializationData;
	}

	function getMetaData()
	{
		return this.MetaData;
	}

	function __readData( _type )
	{
		if (this.SerializationData.len() <= ++this.Idx)
		{
			::logError(format("Tried to read data beyond (%i) the length (%i) of the Deserialization Emulator", this.Idx, this.SerializationData.len()));
			return null;
		}
		local data = this.SerializationData.getDataArray()[this.Idx];
		if (data.getType() != _type)
		{
			::logError(format("The type being read %s isn't the same as the type %s stored in the Deserialization Emulator", ::MSU.Utils.SerializationDataType.getKeyForValue(_type), ::MSU.Utils.SerializationDataType.getKeyForValue(this.SerializationData.getDataArray()[this.Idx].getType())));
			// currently still continuing in case of conversion between integers
		}
		return data.getData();
	}

	function __writeData( _data )
	{
		this.SerializationData.push(_data);
	}

	function writeString( _string )
	{
		::MSU.requireString(_string);
		this.__writeData(_string);
	}

	function writeBool( _bool )
	{
		::MSU.requireBool(_bool);
		this.__writeData(_bool);
	}

	function writeI32( _int )
	{
		::MSU.requireInt(_int);
		this.__writeData(_int);
	}

	function writeU32( _int )
	{
		::MSU.requireInt(_int);
		if (_int < 0)
			throw ::MSU.Exception.InvalidValue(_int);
		this.__writeData(_int);
	}

	function writeI16( _int )
	{
		::MSU.requireInt(_int);
		if (_int < -32768 || _int > 32767)
			throw ::MSU.Exception.InvalidValue(_int);
		this.__writeData(_int);
	}

	function writeU16( _int )
	{
		::MSU.requireInt(_int);
		if (_int < 0 || _int > 65535)
			throw ::MSU.Exception.InvalidValue(_int);
		this.__writeData(_int);
	}

	function writeI8( _int )
	{
		::MSU.requireInt(_int);
		if (_int < -128 || _int > 127)
			throw ::MSU.Exception.InvalidValue(_int);
		this.__writeData(_int);
	}

	function writeU8( _int )
	{
		::MSU.requireInt(_int);
		if (_int < 0 || _int > 255)
			throw ::MSU.Exception.InvalidValue(_int);
		this.__writeData(_int);
	}

	function writeF32( _float )
	{
		::MSU.requireOneFromTypes(["float", "integer"], _float);
		this.__writeData(_float);
	}

	function readString()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.String);
	}

	function readBool()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.Bool);
	}

	function readI32()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.I32);
	}

	function readU32()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.U32);
	}

	function readI16()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.I16);
	}

	function readU16()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.U16);
	}

	function readI8()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.I8);
	}

	function readU8()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.U8);
	}

	function readF32()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.F32);
	}
}
