::MSU.Class.DataArrayData <- class extends ::MSU.Class.CustomSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.DataArray;

	constructor( _metaData )
	{
		base.constructor([], _metaData);
	}

	// overridden functions

	function setMetaData( _metaData )
	{
		if (this.isInitialized())
		{
			::logError("MetaData cannot be changed after the DataArray has been written to");
			throw ::MSU.Exception.InvalidValue(this.isInitialized());
		}
		base.setMetaData(_metaData);
	}

	function setLength( _length )
	{
		this.getData().resize(_length);
	}

	function len()
	{
		return this.getData().len();
	}

	// new functions

	function deserialize( _in )
	{
		base.deserialize(_in);
		for (local i = 0; i < this.len(); ++i)
		{
			this.__loadValue(_idx, _in);
		}
	}

	function serialize( _out )
	{
		base.serialize(_out);
		_out.writeU8(this.DataType.DataArray);
		_out.writeString(this.getMetaData());
		::MSU.Class.U32SerializationData(this.getData().len()).serialize(_out); // store length
		for (local i = 0; i < this.getData().len(); ++i)
		{
			this.getData()[i].serialize(_out);
		}
	}

	function isInitialized()
	{
		return this.__Initialized;
	}

	function getElement( _idx )
	{
		return this.getData()[_idx];
	}

	function pushElement( _value )
	{
		this.getData().push(_value);
	}

	function createDeserializationEmulator( _metaData = null )
	{
		if (_metaData == null) _metaData = ::MSU.Class.MetaDataEmulator();
		return ::MSU.Class.StrictDeserializationEmulator(_metaData, this);
	}

	function createSerializationEmulator( _metaData = null )
	{
		if (_metaData == null) _metaData = ::MSU.Class.MetaDataEmulator();
		return ::MSU.Class.StrictSerializationEmulator(_metaData, this);
	}

	// private functions

	function __loadValue( _idx, _in )
	{
		local type = _in.readU8();
		switch (type)
		{
			case this.DataType.Bool:
				this.getData()[_idx] = ::MSU.Class.BoolSerializationData(_in.readBool());
				break;
			case this.DataType.String:
				this.getData()[_idx] = ::MSU.Class.StringSerializationData(_in.readString());
				break;
			case this.DataType.U8:
				this.getData()[_idx] = ::MSU.Class.U8SerializationData(_in.readU8());
				break;
			case this.DataType.U16:
				this.getData()[_idx] = ::MSU.Class.U16SerializationData(_in.readU16());
				break;
			case this.DataType.U32:
				this.getData()[_idx] = ::MSU.Class.U32SerializationData(_in.readU32());
				break;
			case this.DataType.I8:
				this.getData()[_idx] = ::MSU.Class.I8SerializationData(_in.readI8());
				break;
			case this.DataType.I16:
				this.getData()[_idx] = ::MSU.Class.I16SerializationData(_in.readI16());
				break;
			case this.DataType.I32:
				this.getData()[_idx] = ::MSU.Class.I32SerializationData(_in.readI32());
				break;
			case this.DataType.F32:
				this.getData()[_idx] = ::MSU.Class.F32SerializationData(_in.readF32());
				break;
			case this.DataType.DataArray:
				this.getData()[_idx] = ::MSU.Class.DataArrayData(_in.readString());
				this.getData()[_idx].deserialize(_in);
				break;
			default:
				this.getData()[_idx] = ::MSU.Class.UnknownSerializationData(type, _in.readString());
				this.getData()[_idx].deserialize(_in);
		}
	}
}
