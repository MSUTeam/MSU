// enulates the _in object passed to onDeserialize functions
::MSU.Class.FlagDeserializationEmulator <- class extends ::MSU.Class.FlagSerDeEmulator
{
	function loadDataFromFlagContainer()
	{
		local startString = this.getEmulatorString();
		if (!this.FlagContainer.has(startString))
			return false;

		this.resetData();

		local len = this.FlagContainer.get(startString);
		this.FlagContainer.remove(startString);
		for (local i = 0; i < len; ++i)
		{
			local currentFlag = startString + "." + i;
			if (!this.FlagContainer.has(currentFlag))
				return false;
			this.SerializationData.push(this.FlagContainer.get(currentFlag));
			this.FlagContainer.remove(currentFlag);
		}
		return true;
	}
}
