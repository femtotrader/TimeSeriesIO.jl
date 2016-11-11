using TimeSeriesIO

using Base.Test

# Test convert TimeArray to DataFrame
using TimeSeries
filename = joinpath(basepath(), "ford_2012.csv")
ta2 = readtimearray(filename)
ta2 = ta2["Open", "High", "Low", "Close"]
df2 = DataFrame(ta2)
@test names(df2) == [:Date, :Open, :High, :Low, :Close]

## With optional arguments
df2 = DataFrame(ta2, timestamp=:DateTime, colnames=[:Open, :Close])
@test names(df2) == [:DateTime, :Open, :Close]
