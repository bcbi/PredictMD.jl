import DataFrames

function make_missing_anywhere!(
        df::DataFrames.AbstractDataFrame,
        value_to_replace,
        column_names = DataFrames.names(df),
        )
    for col_name in column_names
        for i = 1:size(df, 1)
            if df[i, col_name] == value_to_replace
                df[i, col_name] = DataFrames.missing
            end
        end
    end
    return nothing
end
