::Const.AI.addBehavior <- function( _id, _name, _order, _score )
{
	if (_id in ::Const.AI.Behavior.ID) throw ::MSU.Exception.DuplicateKey(_id);

	::Const.AI.Behavior.ID[_id] <- ::Const.AI.Behavior.ID.COUNT;
	::Const.AI.Behavior.ID.COUNT += 1;

	::Const.AI.Behavior.Name.push(_name);
	::Const.AI.Behavior.Order[_id] <- _order;
	::Const.AI.Behavior.Score[_id] <- _score;
}
