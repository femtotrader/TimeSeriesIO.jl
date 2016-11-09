using TimeSeriesIO
#using TimeSeriesIO: basepath

using Base.Test

using DataFrames
dat = "Date,Stock,Open,High,Low,Close,Volume
       2016-09-29,KESM,7.92,7.98,7.92,7.97,149400
       2016-09-30,KESM,7.96,7.97,7.84,7.9,29900
       2016-10-04,KESM,7.8,7.94,7.8,7.93,99900
       2016-10-05,KESM,7.93,7.95,7.89,7.93,77500
       2016-10-06,KESM,7.93,7.93,7.89,7.92,130600
       2016-10-07,KESM,7.91,7.94,7.91,7.92,103000"

io = IOBuffer(dat)

df = readtable(io)
df[:Date] = Date(df[:Date])

a_OHLC = ["Open", "High", "Low", "Close"]

# Test convert DataFrame to TimeArray
ta = TimeArray(df, colnames=[:Open, :High, :Low, :Close])
@test ta.colnames == a_OHLC
@test Array(df[[:Open, :High, :Low, :Close]]) == ta.values

ta = TimeArray(df[[:Date, :Open, :High, :Low, :Close]])
@test ta.colnames == a_OHLC
@test Array(df[[:Open, :High, :Low, :Close]]) == ta.values


filename = joinpath(basepath(), "ford_2012.csv")
df = readtable(filename)
df[:Date] = Date(df[:Date])
ta = TimeArray(df, colnames=[:Open, :High, :Low, :Close])
@test ta.colnames == a_OHLC
@test Array(df[[:Open, :High, :Low, :Close]]) == ta.values

# Test convert TimeArray to DataFrame
using TimeSeries
filename = joinpath(basepath(), "ford_2012.csv")
ta2 = readtimearray(filename)
ta2 = ta2["Open", "High", "Low", "Close"]
df2 = DataFrame(ta2)
@test names(df2) == [:Date, :Open, :High, :Low, :Close]
