local gt = this.getroottable();

gt.MSU.setupStringUtils <- function()
{
	this.MSU.String <- {
		
		function getCapital( _string )
		{
			local first = (_string).slice(0, 1);
			first = first.toupper();
			local second = (_string).slice(1);
			return first + second;
		}
	}
}