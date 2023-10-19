::MSU.MH.hook("scripts/ui/global/data_helper", function(q) {
	q.convertCampaignStoragesToUIData = @( __original ) function()
	{
		local queryStorages = ::PersistenceManager.queryStorages;
		::PersistenceManager.queryStorages = function()
		{
			return queryStorages().filter(@(_i, _v) !::MSU.String.startsWith(_v.getFileName(), "MSU#"));
		}
		local ret = __original();
		::PersistenceManager.queryStorages = queryStorages;
		return ret;
	}
});

