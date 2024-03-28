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
	function prefixFileName( _fileName )
	{
		return format("%s%s#%s", ::MSU.System.PersistentData.FilePrefix, this.Mod.getID(), _fileName);
	}

	function createFile( _fileName, _data )
	{
		::MSU.System.PersistentData.createFile(this.prefixFileName(_fileName), ::MSU.Class.ArrayData([_data]));
	}

	function hasFile( _fileName )
	{
		return ::MSU.System.PersistentData.hasFile(this.prefixFileName(_fileName));
	}

	function getFiles()
	{
		local prefix = ::MSU.System.PersistentData.FilePrefix + this.Mod.getID();
		return ::PersistenceManager.queryStorages().filter(@(_i, _v) ::MSU.String.startsWith(_v.getFileName(), prefix))
	}

	function deleteFile( _fileName )
	{
		::PersistenceManager.deleteStorage(this.prefixFileName(_fileName));
	}

	function readFile( _fileName )
	{
		return ::MSU.System.PersistentData.readFile(this.prefixFileName(_fileName)).getData()[0];
	}
}
