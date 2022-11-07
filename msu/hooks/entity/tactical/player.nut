::mods_hookExactClass("entity/tactical/player", function(o) {
	o.m.LevelUpsSpent <- 0;
	o.m.ParagonLevel <- 11;

    local oldCreate = o.create;
    o.create = function()
    {
        oldCreate();
        this.m.ParagonLevel = ::Const.XP.MaxLevelWithPerkpoints;  // Global default value in vanilla
    }

	o.getMovementSpeedMult <- function()
	{
		return 1.0;
	}

    local oldUpdateLevel = o.updateLevel;
    o.updateLevel = function()
    {
        // Switcheroo of the global MaxLevel variable so that BB thinks that each brother may have a different maxlevel
        local oldMaxLevelWithPerkpoints = ::Const.XP.MaxLevelWithPerkpoints;
        ::Const.XP.MaxLevelWithPerkpoints = this.m.ParagonLevel;
        oldUpdateLevel();
        ::Const.XP.MaxLevelWithPerkpoints = oldMaxLevelWithPerkpoints;
    }

    local oldSetScenarioValues = o.setScenarioValues;
    o.setScenarioValues = function()
    {
        // Switcheroo of the global MaxLevel variable so that BB thinks that each brother may have a different maxlevel
        local oldMaxLevelWithPerkpoints = ::Const.XP.MaxLevelWithPerkpoints;
        ::Const.XP.MaxLevelWithPerkpoints = this.m.ParagonLevel;
        oldSetScenarioValues();
        ::Const.XP.MaxLevelWithPerkpoints = oldMaxLevelWithPerkpoints;
    }

    local oldSetStartValuesEx = o.setStartValuesEx;
    o.setStartValuesEx = function( _backgrounds, _addTraits = true )
    {
        // Switcheroo of the global MaxLevel variable so that BB thinks that each brother may have a different maxlevel
        local oldMaxLevelWithPerkpoints = ::Const.XP.MaxLevelWithPerkpoints;
        ::Const.XP.MaxLevelWithPerkpoints = this.m.ParagonLevel;
        oldSetStartValuesEx( _backgrounds, _addTraits = true );
        ::Const.XP.MaxLevelWithPerkpoints = oldMaxLevelWithPerkpoints;
    }

	local setAttributeLevelUpValues = o.setAttributeLevelUpValues;
	o.setAttributeLevelUpValues = function( _v )
	{
		setAttributeLevelUpValues(_v);
		this.m.LevelUpsSpent++;
	}

	local onSerialize = o.onSerialize;
	o.onSerialize = function( _out )
	{
		this.getFlags().set("LevelUpsSpent", this.m.LevelUpsSpent);
		onSerialize(_out);
		this.getFlags().remove("LevelUpsSpent");
	}

	local onDeserialize = o.onDeserialize;
	o.onDeserialize = function( _in )
	{
		onDeserialize(_in);
		this.m.LevelUpsSpent = this.getFlags().has("LevelUpsSpent") ? this.getFlags().get("LevelUpsSpent") : 0;
	}
});
