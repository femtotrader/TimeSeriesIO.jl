struct StreamTimeArray{D<:TimeType, T}

    capacity::Integer
    
    timestamp::CircularBuffer{D}
    values::CircularBuffer{T}

    function StreamTimeArray{D,T}(capacity::Integer) where {D,T}
        new(capacity,
            CircularBuffer{D}(capacity),
            CircularBuffer{T}(capacity))
    end

end

function _assert_datetime_increasing(ta::StreamTimeArray, timestamp)
    if length(ta.timestamp) > 0
        if timestamp <= ta.timestamp[end]
            error("dates must be increasing")
        end
    end
end

function Base.push!(ta::StreamTimeArray, timestamp, data)
    _assert_datetime_increasing(ta, timestamp)
    push!(ta.timestamp, timestamp)
    push!(ta.values, data)
end

Base.length(ta::StreamTimeArray) = length(ta.timestamp)
Base.size(ta::StreamTimeArray) = (length(ta),)
Base.convert(::Type{Array}, ta::StreamTimeArray{T}) where {T} = T[x for x in cb]
Base.isempty(ta::StreamTimeArray) = isempty(ta.timestamp)

capacity(ta::StreamTimeArray) = ta.capacity
isfull(ta::StreamTimeArray) = length(ta) == ta.capacity