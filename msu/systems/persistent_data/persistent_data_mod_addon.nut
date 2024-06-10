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

	function __prefixFileName( _fileName )
	{
		return this.__getFilenamePrefix() +  _fileName;
	}

	function createFile( _fileName, _data )
	{
		::MSU.System.PersistentData.createFile(this.__prefixFileName(_fileName), ::MSU.Serialization.Class.ArrayData([_data]));
	}

	function hasFile( _fileName )
	{
		return ::MSU.System.PersistentData.hasFile(this.__prefixFileName(_fileName));
	}

	function getFiles()
	{
		local prefix = this.__getFilenamePrefix();
		return ::PersistenceManager.queryStorages()
			.map(@(_s) _s.getFileName())
			.filter(@(_, _n) ::MSU.String.startsWith(_n, prefix))
			.map(@(_n) _n.slice(prefix.len()));
	}

	function deleteFile( _fileName )
	{
		::PersistenceManager.deleteStorage(this.__prefixFileName(_fileName));
	}

	function readFile( _fileName )
	{
		return ::MSU.System.PersistentData.readFile(this.__prefixFileName(_fileName)).getData()[0];
	}
}
