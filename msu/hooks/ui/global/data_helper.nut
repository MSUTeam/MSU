::MSU.MH.hook("scripts/ui/global/data_helper", function(q) {
	q.convertCampaignStoragesToUIData = @( __original ) function()
	{
		local queryStorages = ::PersistenceManager.queryStorages;
		::PersistenceManager.queryStorages = function()
		{
			return queryStorages().filter(@(_, _v) !::MSU.String.startsWith(_v.getFileName(), ::MSU.System.PersistentData.FilePrefix));
		}
		local ret = __original();
		::PersistenceManager.queryStorages = queryStorages;
		return ret;
	}

	q.convertCampaignStorageToUIData = @(__original) { function convertCampaignStorageToUIData( _meta )
	{
		local ret = __original(_meta);
		// ret.MSU_ModIncompatibility <- [];

		local modsInfo = ::MSU.Class.SavedModsInfo(_meta);
		ret.MSU_ModIncompatibility <- modsInfo.validateMods();
		if (ret.MSU_ModIncompatibility.len() != 0)
		{
			ret.isIncompatibleVersion = true;
		}

		return ret;
	}}.convertCampaignStorageToUIData ;
});

