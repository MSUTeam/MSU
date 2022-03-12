::MSU.GlobalKeyHandler <- {
    HandlerFunctions = {},
    HandlerFunctionsMap = {},
    States = {
        World = 0,
        Tactical = 1,
        MainMenu = 2,
        All = 4
    },
    InputType = {
        Keyboard = 0,
        Mouse = 1
    },
    PressedKeys = {},

    function addHandlerFunction( _id, _key,  _func, _state = 0, _release = true )
    {
        //adds a new handler function entry, key is the pressed key + modifiers, ID is used to check for custom binds and to modify/remove them
    	local parsedKey = this.MSU.CustomKeybinds.get(_id, _key);
    	if (!(parsedKey in this.HandlerFunctions))
    	{
    	   this.HandlerFunctions[parsedKey] <- [];
    	}
    	this.HandlerFunctions[parsedKey].insert(0, {
    	    ID = _id,
    	    Func = _func,
    	    State = _state,
    	    Release = _release
    	    Key = parsedKey
    	})
    	this.HandlerFunctionsMap[_id] <- this.HandlerFunctions[parsedKey][0];
    }

    function removeHandlerFunction( _id )
    {
        //remove handler function, for example if it's updated or a screen is is destroyed   
        if (!(_id in this.HandlerFunctionsMap))
        {
            ::printWarning("ID " + _id + " not found in Handlerfunctions!", this.MSU.ID, "keybinds");
            return;
        }
        local handlerFunc = this.HandlerFunctionsMap[_id];
        local idx = this.HandlerFunctions[handlerFunc.Key].find(handlerFunc);
        this.HandlerFunctions[handlerFunc.Key].remove(idx);

        if (this.HandlerFunctions[handlerFunc.Key].len() == 0)
        {
            this.HandlerFunctions.rawdelete(handlerFunc.Key);
        }
        this.HandlerFunctionsMap.rawdelete(_id);
        
    }

    function updateHandlerFunction( _id, _key )
    {
        //for when new custom binds are added after handler functions have already been added, for whatever reason
        if (!(_id in this.HandlerFunctionsMap))
        {
            ::printWarning("ID " + _id + " not found in Handlerfunctions!", this.MSU.ID, "keybinds");
            return;
        }
        local handlerFunc = this.HandlerFunctionsMap[_id];
        this.removeHandlerFunction(handlerFunc.ID);
        this.addHandlerFunction(_id, _key, handlerFunc.Func, handlerFunc.State);
    }

    function callHandlerFunction( _key, _env, _state, _release = true )
    { 
        ::printWarning(format("Checking key input: key %s | Environment %s | State %s | Release %s", _key, _env.tostring(), _state.tostring(), _release ? "True" : "False"), this.MSU.ID, "keybinds");
        // call all handler functions if they are present for the key+modifier, if one returns false execution ends
        // executed in order of last added

        if (!(_key in this.HandlerFunctions))
        {
            return;
        }
        local keyFuncArray = this.HandlerFunctions[_key];
        foreach (entry in keyFuncArray) 
        {
            ::printWarning(format("Checking handler function: key %s | ID %s | State %s | Release %s", entry.Key, entry.ID, entry.State.tostring(), entry.Release ? "True" : "False"), this.MSU.ID, "keybinds");
            if (entry.State != this.States.All && entry.State != _state)
            {
                continue;
            }

            if ( _release != entry.Release)
            {
            	continue;
            }

            ::printWarning(format("Calling handler function: key %s | ID %s | State %s | Release %s", entry.Key, entry.ID, entry.State.tostring(), entry.Release ? "True" : "False"), this.MSU.ID, "keybinds");
            if (entry.Func.call(_env) == false)
            {
            	::printWarning("Returning after handlerfunc returned false.", this.MSU.ID, "keybinds");
                return false;
            }
        }
    }


    function processPressedKeys( _key )
    {

    	local key = _key.getKey().tostring();
    	if (!(key in this.MSU.CustomKeybinds.KeyMapSQ))
    	{
    		return false
    	}
    	key = this.MSU.CustomKeybinds.KeyMapSQ[key];
    	local wasPressed = key in this.PressedKeys; //record if it was pressed before
    	if ( _key.getState() == 1 )
    	{
    		this.PressedKeys[key] <- 1;
    		if (wasPressed)
    		{
    			return false;
    		}
    	}
    	else
    	{
    		delete this.PressedKeys[key]
    	}
    	return true //execute keybinds based on it being pressed
    }

    function processInput( _key, _env, _state, _inputType = 0 )
    {
        local keyAsString;
        if (_inputType == this.InputType.Keyboard)
        {
        	keyAsString = _key.getKey().tostring();
        	if (!(keyAsString in this.MSU.CustomKeybinds.KeyMapSQ))
        	{
        		this.logWarning("Unknown key pressed! Key: " + _key.getKey());
        		return;
        	}
        	keyAsString = this.MSU.CustomKeybinds.KeyMapSQ[keyAsString]
        }
        else if (_inputType == this.InputType.Mouse)
        {
        	keyAsString = _key.getID().tostring();
        	if (!(keyAsString in this.MSU.CustomKeybinds.KeyMapSQMouse))
        	{
        		this.logWarning("Unknown key pressed! Key: " + _key.getID());
        		return;
        	}
        	keyAsString = this.MSU.CustomKeybinds.KeyMapSQMouse[keyAsString]
        }
        else
        {
            this.logError(_inputType + " is not a valid input type!");
            return;
        }


        local key = "";
        local pressedKeys = clone this.PressedKeys;
        foreach(pressedKeyID, value in pressedKeys)
        {
        	if(keyAsString != pressedKeyID)
        	{
        		key += pressedKeyID + "+";
        	}
        }
        key += keyAsString;
        return this.callHandlerFunction(key, _env, _state, _key.getState() == 0);
    }
}
