this.MSU.Class.KeybindsSystem <- class extends this.MSU.Class.System
{
	Mods = null;
	KeybindFunctionsByKey = null;
	KeybindFunctionsByMod = null;

	constructor()
	{
		base.constructor(this.MSU.SystemID.Keybinds);
		this.Mods = [];
		this.KeybindFunctionsByKey = {};
		this.KeybindFunctionsByMod = {};
	}

	function registerMod( _modID )
	{
		base.registerMod(_modID);
		this.Mods.push(_modID);
	}


	// maybe add a Bind suffix to all these functions: eg addBind, updateBind etc
	function add( _modID, _id, _key, _function, _state = 0 )
	{
        //adds a new handler function entry, key is the pressed key + modifiers, ID is used to check for custom binds and to modify/remove them

	}

	function removeByMod( _modID, _id )
	{

	}

	function update( _modID, _id, _key )
	{

	}

	function call( _key, _env, _state )
	{

	}

}
