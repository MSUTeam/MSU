::Reforged.HooksMod.hook("scripts/items/helmets/sallet_helmet", function(q) {
	// VANIILLAFIX: https://battlebrothersgame.com/forums/topic/wrong-variant-in-setplainvariant-of-sallet_helmet/
	// https://steamcommunity.com/app/365360/discussions/1/4408543140360563731/
	q.setPlainVariant = @() function()
	{
		this.setVariant(163);
	}
});
