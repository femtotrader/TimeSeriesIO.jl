using TimeSeriesIO: StreamTimeArray

using Base.Test

n = 3
colnames = ["Bid", "Ask"]
ta = StreamTimeArray{DateTime, Float64}(n, colnames)
@test size(ta.values) == (0, length(colnames))

timestamp = DateTime(2010, 1, 1, 20, 31)
td = Dates.Millisecond(1)
push!(ta, timestamp, [1.14, 1.15])
timestamp += td
push!(ta, timestamp, [1.24, 1.25])
timestamp += td
push!(ta, timestamp, [1.34, 1.35])
timestamp += td
push!(ta, timestamp, [1.44, 1.45])

@test size(ta.values) == (3, 2)

@test ta.values[end-2] == [1.24, 1.25]
@test ta.values[end-1] == [1.34, 1.35]
@test ta.values[end] == [1.44, 1.45]

ta = StreamTimeArray{DateTime, Float64}(n, colnames)
timestamp = DateTime(2010, 1, 1, 20, 31)
push!(ta, timestamp, Bid=1.14, Ask=1.15)
@test ta.values[end] == [1.14, 1.15]

timestamp += td
push!(ta, timestamp, Bid=1.24, Ask=1.25)
@test ta.values[end] == [1.24, 1.25]

timestamp += td
push!(ta, timestamp, Bid=1.34, Ask=1.35, NoData=999)  # should we warm that NoData won't be stored?
@test ta.values[end] == [1.34, 1.35]

#timestamp += td
#push!(ta, timestamp, Bid=1.44)  # Ask is missing
#@test ta.values[end] == [1.44, NAN]
#@test_throws KeyError ta.values[end]