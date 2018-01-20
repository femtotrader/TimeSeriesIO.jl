immutable StreamTimeArray{D<:TimeType, T} <: AbstractTimeSeries

    timestamp::NDCircularBuffer
    values::NDCircularBuffer
    colnames::Vector{String}

    function StreamTimeArray{D,T}(capacity::Integer, colnames::Vector{String}) where {D,T}
        new(NDCircularBuffer(D, capacity),
            NDCircularBuffer(T, capacity, length(colnames)),
            colnames)
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


function Base.push!(ta::StreamTimeArray, timestamp; kw_data...)
    _assert_datetime_increasing(ta, timestamp)
    push!(ta.timestamp, timestamp)
    d_data = Dict(kw_data)
    data = Vector{eltype(ta.values)}()
    for colname in ta.colnames
        push!(data, d_data[Symbol(colname)])
    end
    push!(ta.values, data)
end
