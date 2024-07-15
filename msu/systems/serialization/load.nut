function includeFile( _file )
{
	::MSU.includeFile("msu/systems/serialization/", _file);
}
includeFile("metadata_emulator");
includeFile("serde_emulator");
includeFile("flag_serde_emulator");
includeFile("serialization_system");
includeFile("serialization_mod_addon");
::MSU.includeFiles(::IO.enumerateFiles("msu/systems/serialization"));

::MSU.System.Serialization <- ::MSU.Class.SerializationSystem();

::MSU.QueueBucket.AfterHooks.push(function() {
	local worldState = ::new("scripts/states/world_state");
	local serEm = ::MSU.Class.SerializationEmulator(::MSU.Class.MetaDataEmulator());
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
