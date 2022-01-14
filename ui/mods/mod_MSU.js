var GlobalKeyHandler = {
    HandlerFunctions : {},
    AddHandlerFunction : function(_key, _id, _func){
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
                return
            }
        }
    }
}

document.addEventListener('keydown', function(event){
    GlobalKeyHandler.CallHandlerFunction(event.keyCode, event)
} );
