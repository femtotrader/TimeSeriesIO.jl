using TimeSeriesIO: StreamTimeArray

using Base.Test


@testset "StreamTimeArray" begin
    capacity = 3
    colnames = ("Bid", "Ask")
    ta = StreamTimeArray{DateTime, Tuple{Float64,Float64}}(capacity)
    @test ta.capacity == 3
    @test length(ta.values) == 0
    @test size(ta) == (0,)

    # fill!(ta, DateTime(0), (0.0, 0.0))

    timestamp = DateTime(2010, 1, 1, 20, 31)
    td = Dates.Millisecond(1)

    prices = (1.14, 1.15)
    push!(ta, timestamp, prices)
    @test ta.timestamp[end] == DateTime(2010, 1, 1, 20, 31)
    @test length(ta.values) == 1
    @test ta.values[end] == prices

    timestamp += td
    prices = (1.24, 1.25)
    push!(ta, timestamp, prices)
    @test ta.timestamp[end] == DateTime(2010, 1, 1, 20, 31, 0, 1)
    @test length(ta.values) == 2
    @test ta.values[end] == prices

    timestamp += td
    prices = (1.34, 1.35)
    push!(ta, timestamp, prices)
    @test ta.timestamp[end] == DateTime(2010, 1, 1, 20, 31, 0, 2)
    @test length(ta.values) == 3
    @test ta.values[end] == prices

    timestamp += td
    prices = (1.44, 1.45)
    push!(ta, timestamp, prices)
    @test ta.timestamp[end] == DateTime(2010, 1, 1, 20, 31, 0, 3)
    @test length(ta.values) == 3
    @test ta.values[end] == prices

    @test ta.values[end-2] == (1.24, 1.25)
    @test ta.values[end-1] == (1.34, 1.35)
    @test ta.values[end] == (1.44, 1.45)

    println(ta)
end