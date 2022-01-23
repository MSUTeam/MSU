MSU.GlobalKeyHandler = {
    HandlerFunctions : {},
    AddHandlerFunction : function(_key, _id, _func){
        console.error("AddHandlerFunction " + _key + " " + _id)
        if (!(_key in this.HandlerFunctions)){
           this.HandlerFunctions[_key] = []
        }
        this.HandlerFunctions[_key].unshift({
            ID: _id,
            Func: _func
        })
    },
    RemoveHandlerFunction : function(_key, _id){
        if (!(_key in this.HandlerFunctions)){
            return
        }
        var keyFuncArray = this.HandlerFunctions[_key]
        for (var i = 0; i < keyFuncArray.length; i++) {
            if(keyFuncArray[i].ID == _id){
                keyFuncArray.splice(i, 1)
                return
            }
        }       
    },
    CallHandlerFunction : function(_key, event){
        if (!(_key in this.HandlerFunctions)){
            return
        }
        var keyFuncArray = this.HandlerFunctions[_key]
        for (var i = 0; i < keyFuncArray.length; i++) {
            if (keyFuncArray[i].Func(event) === false){
                return false
            }
        }
    }
}
document.addEventListener('keydown', function(event){
    if (MSU.GlobalKeyHandler.CallHandlerFunction(event.keyCode, event) === false){
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



