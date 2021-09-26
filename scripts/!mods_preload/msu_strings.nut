local gt = this.getroottable();

gt.MSU.setupStringUtils <- function()
{
	this.MSU.String <- {
		
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
}