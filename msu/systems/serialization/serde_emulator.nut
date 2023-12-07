// Base for the Serialization and Deserialization Emulators
::MSU.Class.SerDeEmulator <- class
{
	MetaData = null;

	constructor( _metaDataEmulator )
	{
		this.MetaData = _metaDataEmulator;
	}

	function getMetaData()
	{
		return this.MetaData;
	}
}
