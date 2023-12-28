::MSU.Class.SerializationSystem <- class extends ::MSU.Class.System
{
	Mods = null;
	EmulatorsToClear = null;
	MetaData = null;

	SerializationDataType = ::MSU.Class.Enum([
		"Null",
		"Bool",
		"String",
		"U8",
		"U16",
		"U32",
		"I8",
		"I16",
		"I32",
		"F32",
		"Collection",
		"Table",
		"Array",
		"DataArray",
	])
	ReaderFunctionStrings = null;
	WriterFunctionStrings = null;
	constructor()
	{
		base.constructor(::MSU.SystemID.Serialization);
		this.Mods = [];
		this.EmulatorsToClear = [];

		this.ReaderFunctionStrings = {};
		this.ReaderFunctionStrings[this.SerializationDataType.Null] 	<- "readBool";
		this.ReaderFunctionStrings[this.SerializationDataType.Bool] 	<- "readBool";
		this.ReaderFunctionStrings[this.SerializationDataType.String] 	<- "readString";
		this.ReaderFunctionStrings[this.SerializationDataType.U8] 		<- "readU8";
		this.ReaderFunctionStrings[this.SerializationDataType.U16] 		<- "readU16";
		this.ReaderFunctionStrings[this.SerializationDataType.U32] 		<- "readU32";
		this.ReaderFunctionStrings[this.SerializationDataType.I8] 		<- "readI8";
		this.ReaderFunctionStrings[this.SerializationDataType.I16] 		<- "readI16";
		this.ReaderFunctionStrings[this.SerializationDataType.I32] 		<- "readI32";
		this.ReaderFunctionStrings[this.SerializationDataType.F32] 		<- "readF32";

		this.WriterFunctionStrings = {};
		this.WriterFunctionStrings[this.SerializationDataType.Null] 	<- "readBool";
		this.WriterFunctionStrings[this.SerializationDataType.Bool] 	<- "writeBool";
		this.WriterFunctionStrings[this.SerializationDataType.String] 	<- "writeString";
		this.WriterFunctionStrings[this.SerializationDataType.U8] 		<- "writeU8";
		this.WriterFunctionStrings[this.SerializationDataType.U16] 		<- "writeU16";
		this.WriterFunctionStrings[this.SerializationDataType.U32] 		<- "writeU32";
		this.WriterFunctionStrings[this.SerializationDataType.I8] 		<- "writeI8";
		this.WriterFunctionStrings[this.SerializationDataType.I16] 		<- "writeI16";
		this.WriterFunctionStrings[this.SerializationDataType.I32] 		<- "writeI32";
		this.WriterFunctionStrings[this.SerializationDataType.F32] 		<- "writeF32";
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		this.Mods.push(_mod);
		_mod.Serialization = ::MSU.Class.SerializationModAddon(_mod);
	}

	function flagSerialize( _mod, _id, _object, _flags = null )
	{
		if (::MSU.isBBObject(_object))
		{
			::logError("flagSerialize can't serialize a BB Object, you should use <object>.onSerialize(<Mod>.Serialization.getSerializationEmulator())");
			throw ::MSU.Exception.InvalidType("_object");
		}
		if (_flags == null) _flags = ::World.Flags;

		local outEmulator = ::MSU.Class.SerializationEmulator(_mod, _id, _flags);
		this.EmulatorsToClear.push(outEmulator);
		::MSU.Utils.serialize(_object, outEmulator);
		outEmulator.storeDataInFlagContainer(); // should we release data at this point?
	}

	function flagDeserialize( _mod, _id, _defaultValue, _object = null, _flags = null )
	{
		if (::MSU.isBBObject(_object))
		{
			::logError("flagDeserialize can't deserialize a BB Object, you should use <object>.onDeserialize(<Mod>.Serialization.getDeserializationEmulator())");
			throw ::MSU.Exception.InvalidType("_object");
		}
		if (_flags == null) _flags = ::World.Flags;

		local inEmulator = ::MSU.Class.DeserializationEmulator(_mod, _id, _flags);
		if (!inEmulator.loadDataFromFlagContainer())
			return _defaultValue;
		return _object == null ? ::MSU.Utils.deserialize(inEmulator) : ::MSU.Utils.deserializeInto(_object, inEmulator);
	}

	function getDeserializationEmulator( _mod, _id, _flags = null )
	{
		if (_flags == null) _flags = ::World.Flags;
		local emulator = ::MSU.Class.DeserializationEmulator(_mod, _id, _flags);
		emulator.loadDataFromFlagContainer();
		return emulator;
	}

	function getSerializationEmulator( _mod, _id, _flags = null )
	{
		if (_flags == null) _flags = ::World.Flags;
		local emulator = ::MSU.Class.SerializationEmulator(_mod, _id, _flags);
		emulator.setIncremental(true);
		this.EmulatorsToClear.push(emulator);
		return emulator;
	}

	function clearFlags()
	{
		foreach (flagContainer in this.EmulatorsToClear)
			flagContainer.clearFlags();
		this.EmulatorsToClear.clear();
	}

	function readValueFromStorage( _in )
	{
		local type = _in.readU8();
		local dataTypes = this.SerializationDataType;
		if (!this.SerializationDataType.contains(type))
			throw "Unknown type for deserialization! " + type;
		switch (type)
		{
			case dataTypes.Table:
				local table = ::MSU.Class.TableSerializationData(null);
				table.deserialize(_in);
				return table;
			case dataTypes.Array:
				local array = ::MSU.Class.ArraySerializationData(null);
				array.deserialize(_in);
				return array;
			case dataTypes.DataArray:
				local dataArray = ::MSU.Class.DataArrayData();
				dataArray.deserialize(_in);
				return dataArray;
			// validate data right away
			default:
				local data = _in[this.ReaderFunctionStrings[type]]();
				// As there is no null read/write, we need to convert it from a bool
				if (type == dataTypes.Null)
					data = null;
				this.validatePrimitiveData(type, data);
				return ::MSU.Class.PrimitiveSerializationData(type, data);
		}
	}

	function validatePrimitiveData(_type, _data)
	{
		switch (_type){
			case this.SerializationDataType.Null:
				return;
			case this.SerializationDataType.Bool:
				::MSU.requireBool(_data);
				return;
			case this.SerializationDataType.String:
				::MSU.requireString(_data);
				return;
			case this.SerializationDataType.U8:
				::MSU.requireInt(_data);
				if (_data < 0 || _data > 255)
					throw ::MSU.Exception.InvalidValue(_data);
				return;
			case this.SerializationDataType.U16:
				::MSU.requireInt(_data);
				if (_data < 0 || _data > 65535)
					throw ::MSU.Exception.InvalidValue(_data);
				return;
			case this.SerializationDataType.U32:
				::MSU.requireInt(_data);
				if (_data < 0)
					throw ::MSU.Exception.InvalidValue(_data);
				return;
			case this.SerializationDataType.I8:
				::MSU.requireInt(_data);
				if (_data < -128 || _data > 127)
					throw ::MSU.Exception.InvalidValue(_data);
				return;
			case this.SerializationDataType.I16:
				::MSU.requireInt(_data);
				if (_data < -32768 || _data > 32767)
					throw ::MSU.Exception.InvalidValue(_data);
				return;
			case this.SerializationDataType.I32:
				::MSU.requireInt(_data);
				return;
			case this.SerializationDataType.F32:
				::MSU.requireOneFromTypes(["float", "integer"], _data);
				return;
		}
	}

	function convertValueFromBaseType( _value )
	{
		local type = typeof _value;
		local dataTypes = this.SerializationDataType;
		switch (type)
		{
			case "integer":
				if (_value >= 0)
				{
					if (_value <= 255)
					{
						return ::MSU.Class.PrimitiveSerializationData(dataTypes.U8, _value);
					}
					else if (_value <= 65535)
					{
						return ::MSU.Class.PrimitiveSerializationData(dataTypes.U16, _value);
					}
					else
					{
						return ::MSU.Class.PrimitiveSerializationData(dataTypes.U32, _value);
					}
				}
				else
				{
					if (_value >= -128)
					{
						return ::MSU.Class.PrimitiveSerializationData(dataTypes.I8, _value);
					}
					else if  (_value >= -32768)
					{
						return ::MSU.Class.PrimitiveSerializationData(dataTypes.I16, _value);
					}
					else
					{
						return ::MSU.Class.PrimitiveSerializationData(dataTypes.I32, _value);
					}
				}
				break;
			case "string":
				return ::MSU.Class.PrimitiveSerializationData(dataTypes.String, _value);
			case "float":
				return ::MSU.Class.PrimitiveSerializationData(dataTypes.F32, _value);
			case "bool":
				return ::MSU.Class.PrimitiveSerializationData(dataTypes.Bool, _value);
			case "null":
				return ::MSU.Class.PrimitiveSerializationData(dataTypes.Null, _value);
			case "table":
				if (::MSU.isBBObject(_value))
				{
					::logError("MSU Serialization cannot serialize BB Objects directly");
					throw ::MSU.Exception.InvalidValue(_value);
				}
				return ::MSU.Class.TableSerializationData(_value);
			case "array":
				return ::MSU.Class.ArraySerializationData(_value);
			case "instance":
				if (_value instanceof ::MSU.Class.PrimitiveSerializationData || _value instanceof ::MSU.Class.SerializationDataCollection )
					return _value;
				if (_value instanceof ::MSU.Class.StrictSerDeEmulator)
					return _value.getDataArray();
				::logError("MSU Serialization cannot handle instances other than ::MSU.Class.PrimitiveSerializationData and descendants of ::MSU.Class.SerializationDataCollection!");
				throw ::MSU.Exception.InvalidValue(_value);
			default:
				::logError("Attempted to serialize unknown type");
				throw ::MSU.Exception.InvalidType(_value);
		}
	}
}
