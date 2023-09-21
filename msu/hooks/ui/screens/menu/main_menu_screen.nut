::MSU.HooksMod.hook("scripts/ui/screens/menu/main_menu_screen", function(q) {
	q.showMainMenuModule <- function()
	{
		this.m.JSHandle.asyncCall("showMainMenuModule", null);
	}

	q.hideMainMenuModule <- function()
	{
		this.m.JSHandle.asyncCall("hideMainMenuModule", null);
	}

	q.hideNewCampaignModule <- function()
	{
		this.m.JSHandle.asyncCall("hideNewCampaignModule", null);
	}

	q.showNewCampaignModule <- function()
	{
		this.m.JSHandle.asyncCall("showNewCampaignModule", null);
	}

});
