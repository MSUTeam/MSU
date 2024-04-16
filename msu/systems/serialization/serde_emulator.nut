::MSU.Written <- 20;
// Base for the Serialization and Deserialization Emulators
::MSU.Class.SerDeEmulator <- class
{
	MetaData = null;
	SerializationData = null;

	// Used to populate SerializationEmulator and FlagSerializationEmulator classes after their creation to emulate multiple inheritance
	static __ReadFields = {
		Idx = -1,

		function readString()
		{
			return this.__readData(::MSU.Serialization.DataType.String);
		}

		function readBool()
		{
			return this.__readData(::MSU.Serialization.DataType.Bool);
		}

		function readI32()
		{
			return this.__readData(::MSU.Serialization.DataType.I32);
		}

		function readU32()
		{
			return this.__readData(::MSU.Serialization.DataType.U32);
		}

		function readI16()
		{
			return this.__readData(::MSU.Serialization.DataType.I16);
		}

		function readU16()
		{
			return this.__readData(::MSU.Serialization.DataType.U16);
		}

		function readI8()
		{
			return this.__readData(::MSU.Serialization.DataType.I8);
		}

		function readU8()
		{
			return this.__readData(::MSU.Serialization.DataType.U8);
		}

		function readF32()
		{
			return this.__readData(::MSU.Serialization.DataType.F32);
		}
	};

	// Used to populate DeserializationEmulator and FlagDeserializationEmulator classes after their creation to emulate multiple inheritance
	static __WriteFields = {
		function writeString( _string )
		{
			::MSU.requireString(_string);
			this.__writeData(_string, ::MSU.Serialization.DataType.String);
		}

		function writeBool( _bool )
		{
			::MSU.requireBool(_bool);
			this.__writeData(_bool, ::MSU.Serialization.DataType.Bool);
		}

		function writeI32( _int )
		{
			::MSU.requireInt(_int);
			this.__writeData(_int, ::MSU.Serialization.DataType.I32);
		}

		function writeU32( _int )
		{
			::MSU.requireInt(_int);
			if (_int < 0)
				throw ::MSU.Exception.InvalidValue(_int);
			this.__writeData(_int, ::MSU.Serialization.DataType.U32);
		}

		function writeI16( _int )
		{
			::MSU.requireInt(_int);
			if (_int < -32768 || _int > 32767)
				throw ::MSU.Exception.InvalidValue(_int);
			this.__writeData(_int, ::MSU.Serialization.DataType.I16);
		}

		function writeU16( _int )
		{
			::MSU.requireInt(_int);
			if (_int < 0 || _int > 65535)
				throw ::MSU.Exception.InvalidValue(_int);
			this.__writeData(_int, ::MSU.Serialization.DataType.U16);
		}

		function writeI8( _int )
		{
			::MSU.requireInt(_int);
			if (_int < -128 || _int > 127)
				throw ::MSU.Exception.InvalidValue(_int);
			this.__writeData(_int, ::MSU.Serialization.DataType.I8);
		}

		function writeU8( _int )
		{
			::MSU.requireInt(_int);
			if (_int < 0 || _int > 255)
				throw ::MSU.Exception.InvalidValue(_int);
			this.__writeData(_int, ::MSU.Serialization.DataType.U8);
		}

		function writeF32( _float )
		{
			::MSU.requireOneFromTypes(["float", "integer"], _float);
			this.__writeData(_float, ::MSU.Serialization.DataType.F32);
		}
	};

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

	function __writeData( _data, _type )
	{
		if (--::MSU.Written > 0)
		{
			// ::logInfo("Metadata: " + this.getMetaData() + " instance of MetaDataEmulator? " + (this.getMetaData() instanceof ::MSU.Class.MetaDataEmulator));
			// if (!(this.getMetaData() instanceof ::MSU.Class.MetaDataEmulator))
			// {
			// 	::MSU.Log.printData(this.getMetaData());
			// }
			// ::logInfo("Version: " + this.getMetaData().getVersion());
			local info = this.getstackinfos(3);
			::logInfo(format("Writing %s as %s -- %s (%s) - line %i", "" + _data, ::MSU.Serialization.DataType.getKeyForValue(_type), info.func, info.src, info.line));
		}
		this.SerializationData.write(_data, _type);
	}

	function __readData( _type )
	{
		if (this.SerializationData.len() <= ++this.Idx)
		{
			::logError(format("Tried to read data beyond (%i) the length (%i) of the Deserialization Emulator", this.Idx, this.SerializationData.len()));
			return null;
		}
		local data = this.SerializationData.getDataArray()[this.Idx];
		if (this.Idx < 20)
		{
			local info = this.getstackinfos(2);
			::logInfo(format("Reading %s as %s -- %s (%s) - line %i", "" + data.getData(), ::MSU.Serialization.DataType.getKeyForValue(_type), info.func, info.src, info.line));
		}
		if (!data.isTypeValid(_type))
		{
			::logError(format("The type being read %s isn't the same as the type %s (with value: %s) stored in the Deserialization Emulator", ::MSU.Serialization.DataType.getKeyForValue(_type), ::MSU.Serialization.DataType.getKeyForValue(this.SerializationData.getDataArray()[this.Idx].getType()), "" + data.getData()));
			// currently still continuing in case of conversion between integers
			::MSU.Log.printStackTrace();
		}
		return data.getData();
	}
}
