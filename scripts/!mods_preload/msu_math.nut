local gt = this.getroottable();

gt.MSU.setupMathUtils <- function()
{
	// returns log2 of _num, floored (as an int)
	gt.MSU.Math <- {
		function log2int( _num )
		{
			local count = 0;
			while (_num > 1) 
			{
			    _num = _num >> 1;
			    count++;
			}
			return count;
		}
	};
}