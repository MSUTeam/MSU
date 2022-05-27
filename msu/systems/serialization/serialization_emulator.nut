::MSU.Class.SerializationEmulator <- class extends ::MSU.Class.SerDeEmulator
{
	function writeString( _string )
	{
		this.Data.push(_string);
		// idk about the necessity of keeping the type here as well as the value, unless someone can think of a good reason for it I will probably remove it.
	}

	function __writeInt( _int )
	{
		this.Data.push(_int);
	}

	function __writeFloat( _float )
	{
		this.Data.push(_float);
	}

	function writeBool( _bool )
	{
		this.Data.push(_bool);
	}

	function writeI32( _int )
	{
		this.__writeInt(_int);
	}

	function writeU32( _int )
	{
		this.__writeInt(_int);
	}

	function writeI16( _int )
	{
		this.__writeInt(_int);
	}

	function writeU16( _int )
	{
		this.__writeInt(_int);
	}

	function writeI8( _int )
	{
		this.__writeInt(_int);
	}

	function writeU8( _int )
	{
		this.__writeInt(_int);
	}

	function writeF32( _float )
	{
		this.__writeFloat(_float);
	}

	function storeInFlagContainer( _flags )
	{
		local startString = this.getEmulatorString();
		_flags.set(startString, this.Data.len());
		foreach (idx, element in this.Data)
		{
			_flags.set(startString + "." + idx, element);
		}
	}
}
