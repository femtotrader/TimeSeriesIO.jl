module TimeSeriesIO

# package code goes here
export TimeArray, DataFrame

using DataFrames
using TimeSeries
using DataStructures: CircularBuffer

import TimeSeries.TimeArray

include("timearray.jl")
include("dataframe.jl")
include("stream_timearray.jl")
include("stream_timearray_ohlcv.jl")

end # module
