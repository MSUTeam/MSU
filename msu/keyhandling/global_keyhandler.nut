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

    function addHandlerFunction( _id, _key,  _func, _state = 0 )
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

    function callHandlerFunction( _key, _env, _state )
    { 
        ::printWarning(format("Checking handler function for key %s", _key), this.MSU.ID, "keybinds");
        // call all handler functions if they are present for the key+modifier, if one returns false execution ends
        // executed in order of last added

        if (!(_key in this.HandlerFunctions))
        {
            return;
        }
        local keyFuncArray = this.HandlerFunctions[_key];
        foreach (entry in keyFuncArray) 
        {
            ::printWarning(format("Checking handler function: key %s | ID %s | State %s", entry.Key, entry.ID, entry.State.tostring()), this.MSU.ID, "keybinds");
            if (entry.State != this.States.All && entry.State != _state)
            {
                continue;
            }

            ::printWarning(format("Calling handler function: key %s | ID %s | State %s", entry.Key, entry.ID, entry.State.tostring()), this.MSU.ID, "keybinds");
            if (entry.Func.call(_env) == false)
            {
                return false;
            }
        }
    }

    function processInput( _key, _env, _state, _inputType = 0 )
    {
        local key;
        if (_inputType == this.InputType.Keyboard)
        {
            local keyAsString = _key.getKey().tostring();
            if (!(keyAsString in this.MSU.CustomKeybinds.KeyMapSQ))
            {
                this.logWarning("Unknown key pressed! Key: " + _key.getKey());
                return
            }
            key = this.MSU.CustomKeybinds.KeyMapSQ[_key.getKey().tostring()];
            if (_key.getModifier() == 2)
            {
                key += "+ctrl";
            }
            if (_key.getModifier() == 1)
            {
                key += "+shift";
            }
            if (_key.getModifier() == 3)
            {
                key += "+alt";
            }
        }
        else if (_inputType == this.InputType.Mouse)
        {
            local keyAsString = _key.getID().tostring();
            if (!(keyAsString in this.MSU.CustomKeybinds.KeyMapSQMouse))
            {
                this.logWarning("Unknown mouse key pressed! Key: " + _key.getID());
                return;
            }
            key = this.MSU.CustomKeybinds.KeyMapSQMouse[_key.getID().tostring()];
        }
        else
        {
            this.logError(_inputType + " is not a valid input type!");
            return;
        }
        return MSU.GlobalKeyHandler.callHandlerFunction(key, _env, _state);
    }
}
