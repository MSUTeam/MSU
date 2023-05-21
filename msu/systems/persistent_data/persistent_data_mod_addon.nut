::MSU.Class.PersistentDataModAddon <- class extends ::MSU.Class.SystemModAddon
{
	// deprecated bbparser
	function loadFile( _fileID )
	{
		::MSU.System.PersistentData.loadFileForMod(this.Mod.getID(), _fileID);
	}

	function loadAllFiles()
	{
		::MSU.System.PersistentData.loadAllFilesForMod(this.Mod.getID());
	}

	function writeToLog( _fileID, _payload )
	{
		::MSU.System.PersistentData.writeToLog(_fileID, this.Mod.getID(), _payload);
	}

	// MSU 1.3.0
	function createFile( _fileName, _data, _serializationEmulator = null )
	{
		// _data is a table filled with any squirrel types except instances or bb objects
	}

	function loadFile( _fileName )
	{
		return {
			SerializationEmulator = null,
			Data = {}
		}
	}

	function saveValue( _id, _value )
	{
		// _value can be any squirrel type except instance and not a bb object
	}

	function readValue( _id )
	{

	}
}
