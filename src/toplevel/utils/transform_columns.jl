import DataFrames

"""
"""
function transform_columns! end

function transform_columns!(
        df::DataFrames.AbstractDataFrame,
        f::Function,
        column_name::Symbol,
        )::Void
    old_column = df[column_name]
    DataFrames.delete!(df, column_name)
    new_column = fix_type(f(old_column))
    df[column_name] = new_column
    return nothing
end

function transform_columns!(
        df::DataFrames.AbstractDataFrame,
        f::Function,
        column_names::AbstractArray{Symbol},
        )::Void
    for column_name in column_names
        transform_columns!(df, f, column_name)
    end
    return nothing
end
