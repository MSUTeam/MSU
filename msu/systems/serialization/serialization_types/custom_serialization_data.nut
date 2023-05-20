::MSU.Class.CustomSerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	__MetaData = null;

	constructor(_data, _metaData)
	{
		this.__MetaData = _metaData;
		base.constructor(_data);
	}

	function getMetaData()
	{
		return this.__MetaData;
	}

	function setMetaData( _metaData )
	{
		this.__MetaData = _metaData;
	}

	function deserialize( _in )
	{
		local type = _in.readU8();
		if (type != this.DataType.U32)
			throw ::MSU.Exception.InvalidValue(type);
		this.setLength(_in.readU32());
	}

	function serialize( _out )
	{
		_out.writeU8(this.getType());
		_out.writeString(this.getMetaData());
		::MSU.Class.U32SerializationData(this.len()).serialize(_out); // store length
	}

	function setLength( _length )
	{
		throw "TODO" // must be implemented for all containers inheriting from this object
	}

	function len()
	{
		throw "TODO" // must be implemented for all containers inheriting from this object
	}
}
