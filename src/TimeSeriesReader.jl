module TimeSeriesReader

# package code goes here
export to_TimeArray, basepath

using DataFrames
using TimeSeries
include("path.jl")

function to_TimeArray(df::DataFrame; timestamp=:Date, colnames=Symbol[])
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

end # module
