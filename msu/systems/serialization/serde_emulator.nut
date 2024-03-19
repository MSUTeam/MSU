// Base for the Serialization and Deserialization Emulators
::MSU.Class.SerDeEmulator <- class
{
	MetaData = null;
	SerializationData = null;

	constructor( _metaDataEmulator )
	{
		this.MetaData = _metaDataEmulator;
		this.resetData();
	}

	function resetData()
	{
		this.SerializationData = ::MSU.Class.SerializationData();
	}

	function getMetaData()
	{
		return this.MetaData;
	}
}
