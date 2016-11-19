function DataFrame(ta::TimeArray; colnames=Symbol[], timestamp=:Date)
    if length(colnames) != 0
        colnames_str = [string(s) for s in colnames]
        ta = ta[colnames_str...]
    end
    df = DataFrame(hcat(ta.timestamp, ta.values))
    colnames = [Symbol(s) for s in ta.colnames]
    colnames = vcat(timestamp, colnames)
    names!(df, colnames)
    df
end
