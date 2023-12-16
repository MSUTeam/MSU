::MSU.Class.BBObjectData <- class extends ::MSU.Class.SerializationDataCollection
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.BBObject;
	__MetaData = null;
	__Index = null;

	constructor(_data = null)
	{
		base.constructor(_data);
		this.__MetaData = clone ::MSU.System.Serialization.MetaData;
	}

	// overridden functions
	function deserialize( _in, _target )
	{
		local deserEm  = ::MSU.Class.StrictDeserializationEmulator(this);
		this.getMetaData().deserialize(_in);
		local idx = _in.readU8();
		::MSU.Log.printData(_target, 2)
		this.__Data = _target[idx];
		this.__Data.onDeserialize(deserEm);
		base.deserialize(_in, _target);
	}

	function serialize( _out )
	{
		local serEm  = ::MSU.Class.StrictSerializationEmulator(this);
		_out.writeU8(this.getType());
		this.getMetaData().serialize(_out);
		_out.writeU8(this.__Index);
		this.__Data.onSerialize(serEm);
		base.serialize(_out);
	}

	// new functions
	function getMetaData()
	{
		return this.__MetaData;
	}

	function setMetaData( _metaData )
	{
		this.__MetaData = _metaData;
	}
}
