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
	function __getFilenamePrefix()
	{
		return format("%s%s#", ::MSU.System.PersistentData.FilePrefix, this.Mod.getID());
	}

	function __prefixFilename( _filename )
	{
		return this.__getFilenamePrefix() +  _filename;
	}

	function createFile( _filename, _data )
	{
		::MSU.System.PersistentData.createFile(this.__prefixFilename(_filename), ::MSU.Serialization.Class.ArrayData([_data]));
	}

	function hasFile( _filename )
	{
		return ::MSU.System.PersistentData.hasFile(this.__prefixFilename(_filename));
	}

	function getFiles()
	{
		local prefix = this.__getFilenamePrefix();
		return ::PersistenceManager.queryStorages()
			.map(@(_s) _s.getFilename())
			.filter(@(_, _n) ::MSU.String.startsWith(_n, prefix))
			.map(@(_n) _n.slice(prefix.len()));
	}

	function deleteFile( _filename )
	{
		::PersistenceManager.deleteStorage(this.__prefixFilename(_filename));
	}

	function readFile( _filename )
	{
		return ::MSU.System.PersistentData.readFile(this.__prefixFilename(_filename)).getData()[0];
	}
}
