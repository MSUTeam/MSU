::MSU.Class.UnknownSerializationData <- class extends ::MSU.Class.RawDataArrayData
{
	__Type = null;

	constructor( _type )
	{
		this.__Type = _type;
		base.constructor();
	}
}
