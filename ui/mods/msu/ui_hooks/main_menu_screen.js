MainMenuScreen.prototype.showMainMenuModule = function ()
{
	this.mMainMenuModule.show();
	Screens.MSUPopup.setState(Screens.MSUPopup.mLastState);
};

MainMenuScreen.prototype.hideMainMenuModule = function ()
{
	this.mMainMenuModule.hide();
	Screens.MSUPopup.mLastState = Screens.MSUPopup.mState;
	Screens.MSUPopup.setState(Screens.MSUPopup.mStates.None);
};

MainMenuScreen.prototype.hideNewCampaignModule = function ()
{
	this.mNewCampaignModule.hide();
};

MainMenuScreen.prototype.showNewCampaignModule = function ()
{
	this.mNewCampaignModule.show();
	this.mNewCampaignModule.mFirstPanel.removeClass('display-block').addClass('display-none');
	this.mNewCampaignModule.mSecondPanel.removeClass('display-block').addClass('display-none');
	this.mNewCampaignModule.mThirdPanel.addClass('display-block').removeClass('display-none');
	this.mNewCampaignModule.mCancelButton.changeButtonText("Previous");
	this.mNewCampaignModule.mStartButton.changeButtonText("Start");
};

MSU.Hooks.MainMenuScreen_hide = MainMenuScreen.prototype.hide;
MainMenuScreen.prototype.hide = function()
{
	MSU.Hooks.MainMenuScreen_hide.call(this);
	Screens.MSUPopup.mLastState = Screens.MSUPopup.mState;
	Screens.MSUPopup.setState(Screens.MSUPopup.mStates.None);
}

MSU.Hooks.MainMenuScreen_show = MainMenuScreen.prototype.show;
MainMenuScreen.prototype.show = function(_animate)
{
	MSU.Hooks.MainMenuScreen_show.call(this, _animate);
	Screens.MSUPopup.setState(Screens.MSUPopup.mLastState);
}

