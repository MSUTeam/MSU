::MSU.Class.ModSourceNexusMods <- class extends ::MSU.Class.ModSource
{
	static ModSourceDomain = ::MSU.Class.RegistrySystem.ModSourceDomain.NexusMods;
	static Regex = regexp("https:\\/\\/www\\.nexusmods\\.com\\/battlebrothers\\/mods\\/(\\d+)");
	static BadURLMessage = "A NexusMods link must be a link to a specific mod's main page, e.g. 'https://www.nexusmods.com/battlebrothers/mods/479' Check to make sure there's not an issue with your URL and that it is formatted the same way as the MSU URL.";
	static Icon = "nexusmods";
}
