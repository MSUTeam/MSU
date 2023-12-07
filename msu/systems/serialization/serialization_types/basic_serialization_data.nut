::MSU.Class.BasicSerializationData <- class extends ::MSU.Class.AbstractSerializationData
{
	function serialize( _out )
	{
		base.serialize(_out);
		_out["write" + ::MSU.Utils.SerializationDataType.getKeyForValue(this.getType())](this.getData());
	}
}
