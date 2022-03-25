::MSU.Math <- {
	Dist = {
		Normal = class
		{
			Mean = null;
			Std = null;
			static Sqrt = sqrt(2 * ::MSU.Math.pi());

			constructor( _mean, _std )
			{
				::MSU.requireOneFromTypes(["integer", "float"], _mean, _std);
				this.Mean = _mean.tofloat();
				this.Stdev = _std.tofloat();
			}

			function set( _mean, _std )
			{
				::MSU.requireOneFromTypes(["integer", "float"], _mean, _std);
				this.Mean = _mean.tofloat();
				this.Stdev = _std.tofloat();
			}

			function getMean()
			{
				return this.Mean;
			}

			function getStd()
			{
				return this.Std;
			}

			function get( _x )
			{
				return exp(-0.5 * pow((_x - this.Mean)/this.Stdev, 2)) / (_std * this.Sqrt);
			}

			function getNorm( _x )
			{
				return exp(-0.5 * pow((_x - this.Mean)/this.Stdev, 2));
			}

			function getMax()
			{
				return this.get(this.Mean);
			}

			function getProbability( _val1, _val2 )
			{
				return ::Math.abs(this.get(_val1), this.get(_val2));
			}
		}

		Linear = class
		{
			m = null; c = null;
			xMin = null; xMax = null;
			yMin = null; yMax = null;

			constructor( _slope, _yIntercept, _xMin = null, _xMax = null, _yMin = null, _yMax = null )
			{
				::MSU.requireOneFromTypes(["integer", "float"], _slope, _yIntercept);

				this.setBounds(_xMin, _xMax, _yMin, _yMax);
				this.m = _slope.tofloat();
				this.c = _yIntercept.tofloat();
			}

			function get( _x )
			{
				if (this.xMin != null) _x = ::Math.maxf(this.xMin, _x);
				if (this.xMax != null) _x = ::Math.minf(this.xMax, _x);

				local ret = this.m * _x + this.c;

				if (this.yMin != null) ret = ::Math.maxf(this.yMin, ret);
				if (this.yMax != null) ret = ::Math.minf(this.yMax, ret);

				return ret;
			}

			function getSlope()
			{
				return this.m;
			}

			function setSlope( _slope )
			{
				::MSU.requireOneFromTypes(["integer", "float"], _slope);
				this.m = _slope.tofloat();
			}

			function calcSlope( _x1, _x2, _y1, _y2 )
			{
				this.m = ::MSU.Math.linSlope(_x1, _x2, _y1, _y2);
			}

			function getIntercept()
			{
				return this.c;
			}

			function setIntercept( _y )
			{
				::MSU.requireOneFromTypes(["integer", "float"], _y);
				this.c = _y.tofloat();
			}

			function getBounds()
			{
				return { xMin = this.xMin, xMax = this.xMax, yMin = this.yMin, yMax = this.yMax	};
			}

			function setBounds( _xMin, _xMax, _yMin, _yMax )
			{
				if (_xMin != null)
				{
					::MSU.requireOneFromTypes(["integer", "float"], _xMin);
					this.xMin = _xMin;
				}
				if (_xMax != null)
				{
					::MSU.requireOneFromTypes(["integer", "float"], _xMax);
					this.xMax = _xMax;
				}
				if (_yMin != null)
				{
					::MSU.requireOneFromTypes(["integer", "float"], _yMin);
					this.yMin = _yMin;
				}
				if (_yMax != null)
				{
					::MSU.requireOneFromTypes(["integer", "float"], _yMax);
					this.yMax = _xMax;
				}
			}
		}
	},

	function pi()
	{
		return 3.14159;
	}

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

	// Returns the normalized value of the normal distribution at _x
	function normalDistNorm( _x, _mean, _stdev )
	{
		return exp(-0.5 * pow((_x - _mean)/_stdev.tofloat(), 2));
	}

	// Returns the value of the normal distribution at _x
	function normalDist( _x, _mean, _stdev )
	{
		return exp(-0.5 * pow((_x - _mean)/_stdev.tofloat(), 2)) / (_stdev * sqrt(2 * 3.14));
	}

	function linSlope( _x1, _x2, _y1, _y2 )
	{
		::MSU.requireOneFromTypes(["integer", "float"], _x1, _x2, _y1, _y2);
		this.m = (_y2 - _y1) / (_x2 - _x1).tofloat();
	}
};
