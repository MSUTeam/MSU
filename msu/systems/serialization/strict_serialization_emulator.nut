// emulates the _out object passed to onSerialize functions
::MSU.Class.StrictSerializationEmulator <- class extends ::MSU.Class.StrictSerDeEmulator
{
	function __writeData(_data )
	{
		this.getDataArray().Collection.push(_data);
	}

	function writeString( _string )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.String,_string));
	}

	function writeBool( _bool )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.Bool,_bool));
	}

	function writeI32( _int )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.I32,_int));
	}

	function writeU32( _int )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.U22,_int));
	}

	function writeI16( _int )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.I16,_int));
	}

	function writeU16( _int )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.U16, _int));
	}

	function writeI8( _int )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.I8,_int));
	}

	function writeU8( _int )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.U8, _int));
	}

	function writeF32( _float )
	{
		this.__writeData(::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.F32, _float));
	}
}
