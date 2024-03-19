// enulates the _out object passed to onSerialize functions
::MSU.Class.SerializationEmulator <- class extends ::MSU.Class.FlagSerDeEmulator
{
	IsIncremental = false;

	function setIncremental( _bool )
	{
		this.IsIncremental = _bool;
	}

	function __writeData( _data )
	{
		this.SerializationData.push(_data);
		if (this.IsIncremental)
		{
			local startString = this.getEmulatorString();
			this.FlagContainer.set(startString, this.SerializationData.len());
			this.FlagContainer.set(startString + "." + (this.SerializationData.len() - 1), _data);
		}
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

	function storeDataInFlagContainer()
	{
		if (this.IsIncremental)
		{
			::logError("Called storeDataInFlagContainer for an Incremental SerializationEmulator");
			throw ::MSU.Exception.InvalidValue();
		}
		local startString = this.getEmulatorString();
		this.FlagContainer.set(startString, this.SerializationData.len());
		foreach (idx, element in this.SerializationData.getDataRaw())
		{
			this.FlagContainer.set(startString + "." + idx, element);
		}
	}
}
