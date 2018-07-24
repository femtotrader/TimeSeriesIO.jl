using TimeSeriesIO: StreamTimeArrayOHLCV
using TimeFrames

using Base.Test


@testset "StreamTimeArrayOHLCV" begin
    n = 10
    tf = TimeFrame("1H")
    ta_ohlc = StreamTimeArrayOHLCV{DateTime, Float64, Float64}(n, tf)

    @test length(ta_ohlc) == 0
    dt = DateTime(2010, 1, 1, 0, 5, 30)
    td = Dates.Minute(1)

    price = 1.34
    vol = 0.5
    push!(ta_ohlc, dt, price, vol)
    @test ta_ohlc.timestamp[end] == DateTime(2010, 1, 1, 0, 0, 0)
    @test ta_ohlc.price[end] == [1.34, 1.34, 1.34, 1.34]  # opn/high/low/cls
    @test ta_ohlc.volume[end] ≈ 0.5

    dt += td
    price = 1.40  # new high
    vol = 0.1

    push!(ta_ohlc, dt, price, vol)

    @test ta_ohlc.timestamp[end] == DateTime(2010, 1, 1, 0, 0, 0)
    @test ta_ohlc.price[end] == [1.34, 1.40, 1.34, 1.40]  # opn/high/low/cls
    @test ta_ohlc.volume[end] ≈ 0.6

    dt += td
    price = 1.30  # new low
    vol = 0.1
    push!(ta_ohlc, dt, price, vol)
    @test ta_ohlc.timestamp[end] == DateTime(2010, 1, 1, 0, 0, 0)
    @test ta_ohlc.price[end] == [1.34, 1.40, 1.30, 1.30]  # opn/high/low/cls
    @test ta_ohlc.volume[end] ≈ 0.7

    dt += td
    price = 1.35
    vol = 0.1
    push!(ta_ohlc, dt, price, vol)
    @test ta_ohlc.timestamp[end] == DateTime(2010, 1, 1, 0, 0, 0)
    @test ta_ohlc.price[end] == [1.34, 1.40, 1.30, 1.35]  # opn/high/low/cls
    @test ta_ohlc.volume[end] ≈ 0.8

    # new candle
    dt = dt + 60 * td
    price = 1.35
    vol = 0.1
    push!(ta_ohlc, dt, price, vol)
    @test ta_ohlc.timestamp[end] == DateTime(2010, 1, 1, 1, 0, 0)
    @test ta_ohlc.price[end] == [1.35, 1.35, 1.35, 1.35]  # opn/high/low/cls
    @test ta_ohlc.volume[end] ≈ 0.1

    dt += td
    price = 1.36
    vol = 0.1
    push!(ta_ohlc, dt, price, vol)
    @test ta_ohlc.timestamp[end] == DateTime(2010, 1, 1, 1, 0, 0)
    @test ta_ohlc.price[end] == [1.35, 1.36, 1.35, 1.36]  # opn/high/low/cls
    @test ta_ohlc.volume[end] ≈ 0.2

end
