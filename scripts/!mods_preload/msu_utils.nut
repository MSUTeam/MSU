local gt = this.getroottable();

gt.MSU.setupUtils <- function()
{
	gt.MSU.Math <- {
		// returns log2 of _num, floored (as an int)
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

	gt.MSU.String <- {		
		function capitalizeFirst( _string )
		{
			local first = (_string).slice(0, 1);
			first = first.toupper();
			local second = (_string).slice(1);
			return first + second;
		}

		function replace( _string, _find, _replace )
		{
			local idx = _string.find(_find);
			if (idx != null)
			{
				return _string.slice(0, idx) + _replace + _string.slice(idx + _find.len());
			}
			
			return _string;
		}
	}

	gt.MSU.Array <- {
		function getRandom( _array, _start = 0, _end = 0 )
		{
			_end = _end == 0 ? _array.len() - 1 : _end;
			return _array[this.Math.rand(0 + _start, _end)];
		}

		function shuffle( _array )
		{
		    for (local i = _array.len() - 1; i > 0; i--)
		    {
		        local j = this.Math.rand(0, i);

		        local temp = _array[i];
		        _array[i] = _array[j];
		        _array[j]  = temp;
		    }
		}
	}
}