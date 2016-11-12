# TimeSeriesIO

[![Package Evaluator](http://pkg.julialang.org/badges/TimeSeriesIO_0.5.svg)](http://pkg.julialang.org/?pkg=TimeSeriesIO)

[![Build Status](https://travis-ci.org/femtotrader/TimeSeriesIO.jl.svg?branch=master)](https://travis-ci.org/femtotrader/TimeSeriesIO.jl)

[![Build status](https://ci.appveyor.com/api/projects/status/github/femtotrader/timeseriesio.jl?svg=true&branch=master)](https://ci.appveyor.com/project/femtotrader/timeseriesio-jl/branch/master)

[![Coverage Status](https://coveralls.io/repos/femtotrader/TimeSeriesIO.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/femtotrader/TimeSeriesIO.jl?branch=master)

[![codecov.io](http://codecov.io/github/femtotrader/TimeSeriesIO.jl/coverage.svg?branch=master)](http://codecov.io/github/femtotrader/TimeSeriesIO.jl?branch=master)

A Julia library to convert DataFrame to TimeSeries (and otherwise).

## Install

```julia
julia> Pkg.add("TimeSeriesIO")
```

## Usage

```julia
julia> using TimeSeriesIO
```

### Convert DataFrame (from [DataFrames.jl](https://github.com/JuliaStats/DataFrames.jl)) to TimeArray (from [TimeSeries.jl](https://github.com/JuliaStats/TimeSeries.jl))

```julia
julia> ta = TimeArray(df, colnames=[:Open, :High, :Low, :Close], timestamp=:Date)
```

Converts a `DataFrame` named `df` to a `TimeArray` named `ta` keeping only columns defined using `colnames` and using colums defined using `timestamp` as timeseries index.

#### Optional parameters
- `colnames`: If it's not given, all columns will be kept.
- `timestamp`: If it's not given, column named `:Date` will be used as timeseries timestamp index.

### Convert TimeArray (from [TimeSeries.jl](https://github.com/JuliaStats/TimeSeries.jl)) to DataFrame (from [DataFrames.jl](https://github.com/JuliaStats/DataFrames.jl))

```julia
df = DataFrame(ta, colnames=[:Open, :High, :Low, :Close], timestamp=:Date)
```

Converts a `TimeArray` named `ta` to a `DataFrame` named `df` keeping only columns defined using `colnames`.

#### Optional parameters
- `colnames`: If it's not given, all columns will be kept.
- `timestamp`: If it's not given, column named `:Date` will be created.