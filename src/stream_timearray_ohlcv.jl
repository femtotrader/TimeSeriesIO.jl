using TimeFrames: TimeFrame, apply

immutable StreamTimeArrayOHLCV{D<:Dates.TimeType, Tprice, Tvol} <: AbstractTimeSeries

    timestamp::NDCircularBuffer
    price::NDCircularBuffer
    volume::NDCircularBuffer

    timeframe::TimeFrame

    function StreamTimeArrayOHLCV{D,Tprice,Tvol}(capacity::Integer, tf::TimeFrame) where {D,Tprice,Tvol}
        new(NDCircularBuffer(D, capacity),
            NDCircularBuffer(Tprice, capacity, 4),
            NDCircularBuffer(Tvol, capacity), tf)
    end

end

function _assert_datetime_increasing(ta::StreamTimeArrayOHLCV, timestamp)
    if length(ta.timestamp) > 0
        if timestamp <= ta.timestamp[end]
            error("dates must be increasing")
        end
    end
end

function _new_candle(ta::StreamTimeArrayOHLCV, timestamp_round, price, volume)
    println("new candle at $timestamp_round")
    opn, high, low, cls = price, price, price, price
    Base.push!(ta.timestamp, timestamp_round)
    Base.push!(ta.price, [price, price, price, price])
    Base.push!(ta.volume, volume)
end

function Base.push!(ta::StreamTimeArrayOHLCV, timestamp::Dates.TimeType, price, volume)
    _assert_datetime_increasing(ta, timestamp)
    tf = ta.timeframe
    timestamp_round = apply(tf, timestamp)    
    if length(ta.timestamp) > 0
        if ta.timestamp[end] == timestamp_round  # update existing candle
            #println("update")
            opn, high, low, cls = ta.price[end]
            vol = ta.volume[end]

            if price > high
                #println("new high")
                ta.price[end, 2] = price  # new high
            end
            if price < low
                #println("new low")
                ta.price[end, 3] = price  # new low
            end
            println(ta.price[end])
            println(price)
            ta.price[end, 4] = price  # close
            println(ta.price[end])
            ta.volume[end] += volume
        else
            _new_candle(ta, timestamp_round, price, volume)
        end
    else
        _new_candle(ta, timestamp_round, price, volume)
    end
    
end

Base.length(ta::StreamTimeArrayOHLCV) = ta.timestamp.used
Base.isempty(ta::StreamTimeArrayOHLCV) = ta.timestamp.used == 0
capacity(ta::StreamTimeArrayOHLCV) = capacity(ta.timestamp)
