var vanilla_createItemSlot = CharacterScreenInventoryListModule.prototype.createItemSlot;
CharacterScreenInventoryListModule.prototype.createItemSlot = function(_owner, _index, _parentDiv, _screenDiv){
    var result = vanilla_createItemSlot.call(this, _owner, _index, _parentDiv, _screenDiv);
    result.mouseenter(function(_event){
        self.mLastHoveredSlot = $(this).data('item').index;
    })
    result.mouseleave(function(_event){
        self.mLastHoveredSlot = null;
    })
    return result;
}

var vanilla_CharacterScreenInventoryListModule_createDIV = CharacterScreenInventoryListModule.prototype.createDIV;
CharacterScreenInventoryListModule.prototype.createDIV = function(_parentDiv){
    vanilla_CharacterScreenInventoryListModuleDiv.call(this, _parentDiv);
    this.mLastHoveredSlot = null;
}

var vanilla_CharacterScreenInventoryListModule_destroyDIV = CharacterScreenInventoryListModule.prototype.destroyDIV;
CharacterScreenInventoryListModule.prototype.destroyDIV = function(){
    this.mLastHoveredSlot = null;
    vanilla_CharacterScreenInventoryListModule_destroyDIV.call(this);
}