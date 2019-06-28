import DataFrames

"""
"""
function DataFrameFeatureContrasts(
        df::DataFrames.AbstractDataFrame,
        columns::AbstractVector{Symbol},
        )
    num_df_columns = length(unique(columns))
    modelformula = generate_formula(
        columns[1],
        columns;
        intercept = false,
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        df,
        )
    modelschema = modelframe.schema
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    columnsarray = modelmatrix.m
    num_array_columns = size(columnsarray, 2)
    result = DataFrameFeatureContrasts(
        columns,
        num_df_columns,
        modelschema,
        num_array_columns,
        )
    return result
end

"""
"""
function generate_feature_contrasts(
        df::DataFrames.AbstractDataFrame,
        columns::AbstractVector{Symbol},
        )
    result = DataFrameFeatureContrasts(df, columns)
    return result
end
