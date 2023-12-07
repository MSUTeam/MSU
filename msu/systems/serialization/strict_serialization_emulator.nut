// emulates the _out object passed to onSerialize functions
::MSU.Class.StrictSerializationEmulator <- class extends ::MSU.Class.StrictSerDeEmulator
{
	function __writeData(_data )
	{
		this.getDataArray().pushElement(_data);
	}

	function writeString( _string )
	{
		this.__writeData(::MSU.Class.StringSerializationData(_string));
	}

	function writeBool( _bool )
	{
		this.__writeData(::MSU.Class.BoolSerializationData(_bool));
	}

	function writeI32( _int )
	{
		this.__writeData(::MSU.Class.I32SerializationData(_int));
	}

	function writeU32( _int )
	{
		this.__writeData(::MSU.Class.U32SerializationData(_int));
	}

	function writeI16( _int )
	{
		this.__writeData(::MSU.Class.I16SerializationData(_int));
	}

	function writeU16( _int )
	{
		this.__writeData(::MSU.Class.U16SerializationData(_int));
	}

	function writeI8( _int )
	{
		this.__writeData(::MSU.Class.I8SerializationData(_int));
	}

	function writeU8( _int )
	{
		this.__writeData(::MSU.Class.U8SerializationData(_int));
	}

	function writeF32( _float )
	{
		this.__writeData(::MSU.Class.F32SerializationData(_float));
	}
}
