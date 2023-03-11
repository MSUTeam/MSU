::MSU.Class.KeybindSetting <- class extends ::MSU.Class.StringSetting
{
	static Type = "Keybind";

	function __setFromSerializationTable( _table )
	{
		_table.Value = ::String.replace(_table.Value, "tabulator", "tab");
		base.__setFromSerializationTable(_table);
	}
}
