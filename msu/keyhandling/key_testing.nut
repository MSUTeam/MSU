this.MSU.CustomKeybinds.setForJS("testKeybind", "shift+3"); //set new key in JS
this.MSU.CustomKeybinds.set("testKeybind", "f1"); //set new key in SQ
this.MSU.CustomKeybinds.get("testKeybind", "f2"); //get key, returns f1
this.MSU.CustomKeybinds.get("wrongActionID", "f2"); //get key, returns default key f2 as actionID not bound
this.MSU.CustomKeybinds.set("testKeybind", "f3"); //override not specified
this.MSU.CustomKeybinds.set("testKeybind", "f3", true); //override specified

this.MSU.GlobalKeyHandler.addHandlerFunction("test_1", "1",  function(){
	this.logWarning("test_1 runs")
}, 4)
this.MSU.GlobalKeyHandler.addHandlerFunction("test_2", "shift+leftclick",  function(){
	this.logWarning("test_2 runs")
}, 4)
this.MSU.GlobalKeyHandler.addHandlerFunction("test_3", "leftclick",  function(){
	this.logWarning("test_3 runs")
}, 4)
this.MSU.GlobalKeyHandler.addHandlerFunction("test_4", "shift+alt+leftclick",  function(){
	this.logWarning("test_4 runs")
}, 4)

this.MSU.GlobalKeyHandler.addHandlerFunction("test_5", "a+s+d",  function(){
	this.logWarning("test_5 runs")
}, 4)
#this.MSU.CustomKeybinds.set("test_1", ["1", "shift+leftclick", "leftclick", "shift+alt+leftclick"]);
