::MSU.Class.StrictSerDeEmulator <- class extends ::MSU.Class.SerDeEmulator
{
	DataArray = null;

	constructor( _dataArray )
	{
		this.DataArray = _dataArray;
		base.constructor(_dataArray.getMetaData());
	}

	function getDataArray()
	{
		return this.DataArray;
	}
}
