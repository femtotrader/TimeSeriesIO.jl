using TimeFrames: TimeFrame, apply


struct StreamTimeArrayOHLCV{D<:Dates.TimeType, Tprice, Tvol}

    capacity::Integer
    timeframe::TimeFrame

    timestamp::CircularBuffer{D}
    price::CircularBuffer{Vector{Tprice}}
    volume::CircularBuffer{Tvol}

    function StreamTimeArrayOHLCV{D,Tprice,Tvol}(capacity::Integer, tf::TimeFrame) where {D,Tprice,Tvol}
        new(
            capacity,
            tf,
            CircularBuffer{D}(capacity),
            CircularBuffer{Vector{Tprice}}(capacity),
            CircularBuffer{Tvol}(capacity))
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
    #println("new candle at $timestamp_round")
    opn, high, low, cls = price, price, price, price
    Base.push!(ta.timestamp, timestamp_round)
    prices = [price, price, price, price]
    Base.push!(ta.price, prices)
    Base.push!(ta.volume, volume)
end

function Base.push!(ta::StreamTimeArrayOHLCV, timestamp::Dates.TimeType, price, volume)
    _assert_datetime_increasing(ta, timestamp)
    tf = ta.timeframe
    timestamp_round = apply(tf, timestamp)
    idx = length(ta.timestamp)
    if idx > 0
        if ta.timestamp[idx] == timestamp_round  # update existing candle
            #println("update")
            opn, high, low, cls = ta.price[idx]
            vol = ta.volume[idx]

            if price > high
                #println("new high")
                ta.price[idx][2] = price  # new high
            end
            if price < low
                #println("new low")
                ta.price[idx][3] = price  # new low
            end
            #println(ta.price[idx])
            #println(price)
            ta.price[idx][4] = price  # close
            #println(ta.price[idx])
            ta.volume[idx] += volume
        else
            _new_candle(ta, timestamp_round, price, volume)
        end
    else
        _new_candle(ta, timestamp_round, price, volume)
    end
    
end

Base.length(ta::StreamTimeArrayOHLCV) = length(ta.timestamp)
Base.isempty(ta::StreamTimeArrayOHLCV) = length(ta) == 0
capacity(ta::StreamTimeArrayOHLCV) = capacity(ta.timestamp)
