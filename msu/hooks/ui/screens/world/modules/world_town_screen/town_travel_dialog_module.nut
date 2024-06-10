// VANILLAFIX https://steamcommunity.com/app/365360/discussions/1/4334231842064065638/
::MSU.MH.hook("scripts/ui/screens/world/modules/world_town_screen/town_travel_dialog_module", function(q) {
	q.fastTravelTo = @(__original) function( _dest ) {
		::World.State.getCurrentTown().onLeave();
		__original(_dest);
	}
});
