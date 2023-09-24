::MSU.HooksMod.hook("scripts/ui/screens/menu/modules/main_menu_module", function(q) {
	q.m.OnModOptionsPressedListener <- null;

	q.setOnModOptionsPressedListener <- function( _listener )
	{
		this.m.OnModOptionsPressedListener = _listener;
	}

	q.onModOptionsButtonPressed <- function()
	{
		this.m.OnModOptionsPressedListener();
	}

	q.create = @(__original) function()
	{
		__original();
		::MSU.Popup.quitGame = o.onQuitButtonPressed.bindenv(this);
	}

	q.connectBackend <- function()
	{
		::MSU.Popup.connect();
		if ("UI" in ::MSU)
		{
			::MSU.UI.connect();
		}
	}
});
