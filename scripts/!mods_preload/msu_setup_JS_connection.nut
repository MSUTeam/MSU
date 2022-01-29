local gt = this.getroottable();

gt.MSU.setupBackendConnection <- function(){
	//Setup after main menu is fully loaded
	::mods_hookNewObject("ui/screens/menu/main_menu_screen", function(o){
		o.setupJSConnection <- function(){
			gt.MSU.setupJSConnection();
		}
	})

	gt.MSU.setupJSConnection <- function() {
		gt.MSU.JSConnection <- this.new("scripts/ui/msu_JS_connection");
	}

	::mods_registerJS("~~msu_backend_connection.js")
}
