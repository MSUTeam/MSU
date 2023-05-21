::MSU.Class.NullSerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.Null;
	constructor( _data = null )
	{
		base.constructor(null);
	}

	function serialize( _out )
	{
		_out.writeU8(this.getType());
	}
}
