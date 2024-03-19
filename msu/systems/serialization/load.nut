function includeFile( _file )
{
	::MSU.includeFile("msu/systems/serialization/", _file);
}
includeFile("metadata_emulator");
includeFile("serde_emulator");
includeFile("flag_serde_emulator");
includeFile("flag_serialization_emulator");
includeFile("flag_deserialization_emulator");
includeFile("serialization_emulator");
includeFile("deserialization_emulator");

includeFile("serialization_system.nut");
::MSU.System.Serialization <- ::MSU.Class.SerializationSystem();
includeFile("serialization_mod_addon.nut");

::MSU.includeFiles(::IO.enumerateFiles("msu/systems/serialization/serialization_types"));

::MSU.UI.addOnConnectCallback(function()
{
	local worldState = ::new("scripts/states/world_state");
	local serEm = ::MSU.Class.FlagSerializationEmulator(::MSU.ID, "WorldStateOnBeforeSerialize", ::new("scripts/tools/tag_collection"), ::MSU.Class.MetaDataEmulator());
	::MSU.System.Serialization.MetaData = serEm.getMetaData();
	::World.Assets <- {
		getName = @() "msuDummy",
		getBanner = @() "msuDummy",
		getCombatDifficulty = @() 1,
		getEconomicDifficulty = @() 1,
		isIronman = @() false,
	}
	::World.Assets.setdelegate({ // attempted patch for any other function calls
		_get = @(_k)@(...)""
	});
	worldState.onBeforeSerialize(serEm);
	delete ::World.Assets;
});
