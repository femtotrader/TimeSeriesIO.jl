module TimeSeriesIO

# package code goes here
export TimeArray, DataFrame

using DataFrames
using TimeSeries

import TimeSeries.TimeArray

include("timearray.jl")
include("dataframe.jl")
include("nd_circular_buffer.jl")
include("stream_timearray.jl")
include("stream_timearray_ohlcv.jl")

end # module
