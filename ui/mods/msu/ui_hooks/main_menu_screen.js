MainMenuScreen.prototype.showMainMenuModule = function ()
{
	this.mMainMenuModule.show();
};

MainMenuScreen.prototype.hideMainMenuModule = function ()
{
	this.mMainMenuModule.hide();
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
	MSU.Popup.setState(MSU.Popup.mState.None);
	MSU.Popup.mSmallContainer.removeClass("msu-popup-main-menu-screen");
}
