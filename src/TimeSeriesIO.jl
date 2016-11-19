module TimeSeriesIO

# package code goes here
export TimeArray, DataFrame

using DataFrames
using TimeSeries
using DataStructures: CircularBuffer

import TimeSeries.TimeArray

include("timearray.jl")
include("dataframe.jl")

end # module
