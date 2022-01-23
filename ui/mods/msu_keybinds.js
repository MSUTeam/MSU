MSU.GlobalKeyHandler = {
    HandlerFunctions : {},
    ParseModifiers : function(_key){
        var keyArray = _key.split('+')
        //reorder arguments
        var parsedKey = keyArray[0];
        if(keyArray.find("shift") != undefined){
            parsedKey = parsedKey + "+shift"
        }
        if(keyArray.find("ctrl") != undefined){
            parsedKey = parsedKey + "+ctrl"
        }
        if(keyArray.find("alt") != undefined){
            parsedKey = parsedKey + "+alt"
        }
        return parsedKey
    },
    AddHandlerFunction : function(_key, _id, _func){
        var parsedKey = this.ParseModifiers(_key)
        if (!(parsedKey in this.HandlerFunctions)){
           this.HandlerFunctions[parsedKey] = []
        }
        this.HandlerFunctions[parsedKey].unshift({
            ID: _id,
            Func: _func
        })
    },
    RemoveHandlerFunction : function(_key, _id){
        var parsedKey = this.ParseModifiers(_key)
        if (!(parsedKey in this.HandlerFunctions)){
            return
        }
        var keyFuncArray = this.HandlerFunctions[parsedKey]
        for (var i = 0; i < keyFuncArray.length; i++) {
            if(keyFuncArray[i].ID == _id){
                keyFuncArray.splice(i, 1)
                return
            }
        }       
    },
    CallHandlerFunction : function(_key, _shiftPressed, _ctrlPressed, _altPressed, event){
        
        var parsedKey = _key;
        if (_shiftPressed){
            parsedKey = parsedKey + "+shift"
        }
        if (_ctrlPressed){
            parsedKey = parsedKey + "+ctrl"
        }
        if (_altPressed){
            parsedKey = parsedKey + "+alt"
        }
        if (!(parsedKey in this.HandlerFunctions)){
            return
        }
        var keyFuncArray = this.HandlerFunctions[parsedKey]
        for (var i = 0; i < keyFuncArray.length; i++) {
            if (keyFuncArray[i].Func(event) === false){
                return false
            }
        }
    }
}
document.addEventListener('keydown', function(_event){
    var key = _event.keyCode
    var shiftPressed = (KeyModiferConstants.ShiftKey in _event && _event[KeyModiferConstants.ShiftKey] === true);
    var ctrlPressed = (KeyModiferConstants.CtrlKey in _event && _event[KeyModiferConstants.CtrlKey] === true);
    var altPressed = (KeyModiferConstants.AltKey in _event && _event[KeyModiferConstants.AltKey] === true);

    if (MSU.GlobalKeyHandler.CallHandlerFunction(key, shiftPressed, ctrlPressed, altPressed, event) === false){
        event.stopPropagation()
    }
});


MSU.CustomKeybinds = {
    CustomBinds : {},
    get : function(_actionID, _defaultKey){
        if (_actionID in this.CustomBinds){
            return this.CustomBinds[_actionID]
        }
        return _defaultKey
    },
    setFromSQ : function(_keyBinds){
        //set all keys and replace old binds (futureproof for possible keybind mod)
        var handlerFunctions = MSU.GlobalKeyHandler.HandlerFunctions
        Object.keys(_keyBinds).forEach(function (prop) { 
            var actionID = prop
            var key = _keyBinds[prop]
            MSU.CustomKeybinds.CustomBinds[actionID] = key
            Object.keys(handlerFunctions).forEach(function (handerFuncKey) {
                var handlerFuncArray = handlerFunctions[handerFuncKey]
                for (var j = 0; j < handlerFuncArray.length; j++) {
                    if(handlerFuncArray[j].ID == actionID){
                        var result = handlerFuncArray.splice(j, 1)
                        MSU.GlobalKeyHandler.AddHandlerFunction(key, actionID, result[0].Func)
                    }
                } 
            })
        });
    }
}


SQ.call(Screens["MSUBackendConnection"].mSQHandle, 'passKeybinds');



