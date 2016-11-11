module TimeSeriesIO

# package code goes here
export TimeArray, DataFrame, basepath

using DataFrames
using TimeSeries
include("path.jl")

import TimeSeries.TimeArray

function TimeArray(df::DataFrame; colnames=Symbol[], timestamp=:Date)
    if length(colnames) == 0
        colnames = names(df)
        colnames = filter(s->s!=timestamp, colnames)
    end
    colnames_str = [string(s) for s in colnames]
    a_timestamp = Array(df[timestamp])
    a_values = Array(df[colnames])
    ta = TimeArray(a_timestamp, a_values, colnames_str)
    ta
end

function DataFrame(ta::TimeArray; colnames=Symbol[], timestamp=:Date)
    df = DataFrame(hcat(ta.timestamp, ta.values))
    if length(colnames) == 0
        colnames = [Symbol(s) for s in ta.colnames]
    end
    colnames = vcat(timestamp, colnames)
    names!(df, colnames)
    df
end

end # module
