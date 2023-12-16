::MSU.Class.PrimitiveSerializationData <- class
{
	__Type = null;
	__Data = null;

	constructor( _type, _data )
	{
		this.__Type = _type;
		this.__Data = _data;
	}

	function getType()
	{
		return this.__Type;
	}

	function getData()
	{
		return this.__Data;
	}

	function serialize( _out )
	{
		_out.writeU8(this.getType());
		_out[this.getWriteFunctionString()](this.getData());
	}

	function getWriteFunctionString()
	{
		return ::MSU.System.Serialization.WriterFunctionStrings[this.getType()];
	}

	function getReadFunctionString()
	{
		return ::MSU.System.Serialization.ReaderFunctionStrings[this.getType()];
	}
}
