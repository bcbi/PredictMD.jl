import DataFrames

"""
"""
struct DataFrameFeatureContrasts <: AbstractFeatureContrasts
    columns::T1 where T1 <: AbstractVector{Symbol}
    num_df_columns::T2 where T2 <: Integer
    contrasts::T3 where T3 <: Associative
    num_array_columns::T4 where T4 <: Integer
end

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
    contrasts = modelframe.contrasts
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    columnsarray = modelmatrix.m
    num_array_columns = size(columnsarray, 2)
    result = DataFrameFeatureContrasts(
        columns,
        num_df_columns,
        contrasts,
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
    result = DataFrameFeatureContrasts(df,columns)
    return result
end
