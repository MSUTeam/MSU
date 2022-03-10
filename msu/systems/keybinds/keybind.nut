this.MSU.Class.Keybind <- class
{
	Key = null;
	ModID = null;
	ID = null;
	Name = null;
	Description = null;
	Function = null;

	constructor( _modID, _id, _key, _name = null )
	{

	}

	function parseModifiers( _key )
	{
		//reorder modifiers so that they are always in the same order
		local keyArray = split(_key, "+");
		local key = keyArray.pop();

		//TODO Needs to throw an error if key == shift/ctrl/alt

		local parsedKey = "";
		local findAndAdd = function( _arr, _key )
		{
		    if (_arr.find(_key) != null)
		    {
		        parsedKey += _key + "+";
		        return;
		    }
		}
		findAndAdd(keyArray, "shift");
		findAndAdd(keyArray, "ctrl");
		findAndAdd(keyArray, "alt");
		parsedKey += key;
		return parsedKey;
	}

	function call( _env )
	{
		this.Function.call(_env);
	}
}
