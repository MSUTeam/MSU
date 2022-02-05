MSU.GlobalKeyHandler = {
    HandlerFunctions : {},
    HandlerFunctionsMap : {},
    AddHandlerFunction : function(_id, _key, _func){
        //adds a new handler function entry, key is the pressed key + modifiers, ID is used to check for custom binds and to modify/remove them
        var parsedKey = MSU.CustomKeybinds.get(_id, _key)
        if (!(parsedKey in this.HandlerFunctions)){
           this.HandlerFunctions[parsedKey] = []
        }
        this.HandlerFunctions[parsedKey].unshift({
            ID: _id,
            Func: _func,
            Key: parsedKey
        })
        this.HandlerFunctionsMap[_id] = this.HandlerFunctions[parsedKey][0]
    },
    RemoveHandlerFunction : function(_id, _key){
        //remove handler function, for example if screen is destroyed
        if(!(_id in this.HandlerFunctionsMap)){
            return
        }
        var handlerFunc = this.HandlerFunctionsMap[_id]
        var parsedKey = MSU.CustomKeybinds.ParseModifiers(_key)
        var keyFuncArray = this.HandlerFunctions[parsedKey]
        for (var i = 0; i < keyFuncArray.length; i++) {
            if(keyFuncArray[i].ID == _id){
                keyFuncArray.splice(i, 1)
                if(keyFuncArray.length == 0){
                    delete this.HandlerFunctions[parsedKey]
                }
                return
            }
        } 
        delete this.HandlerFunctionsMap[handlerFunc.Key]      
    },
    UpdateHandlerFunction : function(_id, _key){
        if(!(_id in this.HandlerFunctionsMap)){
            return
        }
        var handlerFunc = this.HandlerFunctionsMap[_id]
        this.RemoveHandlerFunction(handlerFunc.ID, handlerFunc.Key)
        this.AddHandlerFunction(_id, _key, handlerFunc.Func)
    },

    CallHandlerFunction : function(_key, event){ 
        // call all handler functions if they are present for the key+modifier, if one returns false execution ends
        // executed in order of last added
        if (!(_key in this.HandlerFunctions)){
            return
        }
        var keyFuncArray = this.HandlerFunctions[_key];
        for (var i = 0; i < keyFuncArray.length; i++){
            if (keyFuncArray[i].Func(event) === false){
                return false
            }
        }
    },
    ProcessInput : function(_key, _event){
        if (_event.shiftKey === true){
            _key += "+shift"
        }
        if (_event.ctrlKey === true){
            _key += "+ctrl"
        }
        if (_event.altKey === true){
            _key += "+alt"
        }
        return this.CallHandlerFunction(_key)
    }
}
document.addEventListener('keyup', function(_event){
    //transform key into string, add possible modifiers
    var key = MSU.CustomKeybinds.KeyMapJS[_event.keyCode]
    if (key === undefined || key === null){
        return
    }
    if (MSU.GlobalKeyHandler.ProcessInput(key, _event) === false){
        event.stopPropagation()
    }
});
document.addEventListener('mouseup', function(_event){
    //transform key into string, add possible modifiers
    var key = MSU.CustomKeybinds.KeyMapJSMouse[_event.button]
    if (key === undefined || key === null){
        return
    }
    if (MSU.GlobalKeyHandler.ProcessInput(key, _event) === false){
        event.stopPropagation()
    }
});



MSU.CustomKeybinds = {
    CustomBinds : {},
    KeyMapJS : {
        8 :"backspace",
        9 :"tabulator",
        13 :"return",
        16 :"shift",
        17 :"ctrl",
        18 :"alt",
        19 :"pause",
        20 :"capslock",
        27 :"escape",
        32 :"space",
        33 :"pageup",
        34 :"pagedown",
        35 :"end",
        36 :"home",
        37 :"left",
        38 :"up",
        39 :"right",
        40 :"down",
        45 :"insert",
        46 :"delete",
        48 :"0",
        49 :"1",
        50 :"2",
        51 :"3",
        52 :"4",
        53 :"5",
        54 :"6",
        55 :"7",
        56 :"8",
        57 :"9",
        65 :"a",
        66 :"b",
        67 :"c",
        68 :"d",
        69 :"e",
        70 :"f",
        71 :"g",
        72 :"h",
        73 :"i",
        74 :"j",
        75 :"k",
        76 :"l",
        77 :"m",
        78 :"n",
        79 :"o",
        80 :"p",
        81 :"q",
        82 :"r",
        83 :"s",
        84 :"t",
        85 :"u",
        86 :"v",
        87 :"w",
        88 :"x",
        89 :"y",
        90 :"z",
        91 :"leftwindowkey",
        92 :"rightwindowkey",
        93 :"selectkey",
        96 :"n0",
        97 :"n1",
        98 :"n2",
        99 :"n3",
        100 :"n4",
        101 :"n5",
        102 :"n6",
        103 :"n7",
        104 :"n8",
        105 :"n9" ,
        106 :"*" ,
        107 :"+",
        112 :"f1",
        113 :"f2",
        114 :"f3",
        115 :"f4",
        116 :"f5",
        117 :"f6",
        118 :"f7",
        119 :"f8",
        120 :"f9",
        121 :"f10",
        122 :"f11",
        123 :"f12",
        124 :"f13",
        125 :"f14",
        126 :"f15",
        127 :"f16",
        128 :"f17",
        129 :"f18",
        130 :"f19",
        131 :"f20",
        132 :"f21",
        133 :"f22",
        134 :"f23",
        135 :"f24",
        144 :"numlock",
        145 :"scrolllock",
        186 :"semicolon",
        187 :"equalsign",
        188 :"comma",
        189 :"dash",
        190 :"dot",
        191 :"forwardslash",
        192 :"graveaccent",
        219 :"openbracket",
        220 :"backslash",
        221 :"closebracket",
        222 :"singlequote"
    },
    KeyMapJSMouse : {
        0 : "leftclick",
        2 : "rightclick",
    },
    ParseModifiers : function(_key){
        //reorder modifiers so that they are always in the same order
        var keyArray = _key.split('+')
        var parsedKey = keyArray[0];
        var findAndAdd = function(_arr, _key){
            for(var i = 0; i < _arr.length; i++){
                if(_arr[i] == _key){
                    parsedKey += "+" + _key
                    return
                }
            }
        }
        findAndAdd(keyArray, "shift")
        findAndAdd(keyArray, "ctrl")
        findAndAdd(keyArray, "alt")
        return parsedKey
    },
    get : function(_actionID, _defaultKey){
        // get key for actionID, if none is present returns default key
        if (_actionID in this.CustomBinds){
            return this.CustomBinds[_actionID]
        }
        return _defaultKey
    },
    set: function(_actionID, _key){
        _key = this.ParseModifiers(_key)
        this.CustomBinds[_actionID] = _key
        MSU.GlobalKeyHandler.UpdateHandlerFunction(_actionID, _key)
    },
    setFromSQ : function(_keyBinds){
        // set new custom binds gotten from SQ
        Object.keys(_keyBinds).forEach(function (_actionID){ 
            this.set(_actionID, _keyBinds[_actionID])
        }.bind(this));
    }
}

//fetch custom binds from SQ
SQ.call(Screens["MSUBackendConnection"].mSQHandle, 'passKeybinds');

// For testing, need to pass over debugging status to JS maybe so that we can run better testing 

// MSU.GlobalKeyHandler.AddHandlerFunction("lmb", "leftclick", function(){
//     console.error("pressed lmb")
// })
// MSU.GlobalKeyHandler.AddHandlerFunction("lmbshift", "leftclick+shift", function(){
//     console.error("pressed lmbshift")
// })
// MSU.GlobalKeyHandler.AddHandlerFunction("lmbctrl", "leftclick+ctrl", function(){
//     console.error("pressed lmbctrl")
// })
// MSU.GlobalKeyHandler.AddHandlerFunction("lmbalt", "leftclick+alt", function(){
//     console.error("pressed lmbalt")
// })

// MSU.GlobalKeyHandler.AddHandlerFunction("rmb", "rightclick", function(){
//     console.error("pressed rmb")
// })
// MSU.GlobalKeyHandler.AddHandlerFunction("rmbshift", "rightclick+shift", function(){
//     console.error("pressed rmbshift")
// })
// MSU.GlobalKeyHandler.AddHandlerFunction("rmbctrl", "rightclick+ctrl", function(){
//     console.error("pressed rmbctrl")
// })
// MSU.GlobalKeyHandler.AddHandlerFunction("rmbalt", "rightclick+alt", function(){
//     console.error("pressed rmbalt")
// })