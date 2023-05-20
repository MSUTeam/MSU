::MSU.Class.StrictSerDeEmulator <- class extends ::MSU.Class.SerDeEmulator
{
	DataArray = null;

	constructor( _metaData, _dataArray )
	{
		base.constructor(_metaData);
		this.DataArray = _dataArray;
	}

	function getDataArray()
	{
		return this.DataArray;
	}
}
