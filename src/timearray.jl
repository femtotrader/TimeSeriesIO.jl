function TimeArray(df::DataFrame; colnames=Symbol[], timestamp=:Date)
    if length(colnames) != 0
        df = df[vcat(timestamp, colnames)]
    else
        colnames = names(df)
        colnames = filter(s->s!=timestamp, colnames)
    end
    colnames_str = [string(s) for s in colnames]
    a_timestamp = Array(df[timestamp])
    a_values = Array(df[colnames])
    ta = TimeArray(a_timestamp, a_values, colnames_str)
    ta
end
