::MSU.Class.UnknownSerializationData <- class extends ::MSU.Class.DataArrayData
{
	__Type = null;

	constructor( _type, _data )
	{
		this.__Type = _type;
		base.constructor(_data);
	}
}
