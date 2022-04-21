::MSU.Class.PersistentDataModAddon <- class extends ::MSU.Class.SystemModAddon
{
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
}
