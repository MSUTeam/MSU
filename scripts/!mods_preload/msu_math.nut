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

		// Returns the frequency density of _x using normal distribution
		function normalDistDensity(_x, _mean, _stdev)
		{
			local divider = _stdev * sqrt(2 * 3.14);

			local val = exp(-0.5 * pow((_x - _mean)/(_stdev * 1.0), 2)) / divider;

			local valAtMean = 1 / divider;

			return val / valAtMean;
		}

		// Returns the value of the normal distribution at _x
		function normalDist(_x, _mean, _stdev)
		{
			return exp(-0.5 * pow((_x - _mean)/(_stdev * 1.0), 2)) / (_stdev * sqrt(2 * 3.14));			
		}
	};
}