import DataFrames

"""
"""
function DataFrameFeatureContrasts(
        df::DataFrames.AbstractDataFrame,
        columns::AbstractVector{Symbol},
        )
    columns_deepcopy = deepcopy(columns)
    if length(columns_deepcopy) != length(unique(columns_deepcopy))
        error("length(columns_deepcopy) != length(unique(columns_deepcopy))")
    end
    num_df_columns_deepcopy = length(columns_deepcopy)
    formula_wo_intercept = generate_formula(
        columns_deepcopy[1],
        columns_deepcopy;
        intercept = false,
        )
    formula_with_intercept = generate_formula(
        columns_deepcopy[1],
        columns_deepcopy;
        intercept = true,
        )
    schema_wo_intercept = StatsModels.schema(formula_wo_intercept, df)
    schema_with_intercept = StatsModels.schema(formula_with_intercept, df)
    formula_wo_intercept = StatsModels.apply_schema(formula_wo_intercept,
                                                    schema_wo_intercept)
    formula_with_intercept = StatsModels.apply_schema(formula_with_intercept,
                                                      schema_with_intercept)
    response_wo_intercept, predictors_wo_intercept =
        StatsModels.modelcols(formula_wo_intercept, df)
    response_with_intercept, predictors_with_intercept =
        StatsModels.modelcols(formula_with_intercept, df)
    num_array_columns_wo_intercept = size(predictors_wo_intercept, 2)
    num_array_columns_with_intercept = size(predictors_with_intercept, 2)
    result = DataFrameFeatureContrasts(
        columns_deepcopy,
        num_df_columns_deepcopy,
        schema_wo_intercept,
        formula_wo_intercept,
        num_array_columns_wo_intercept,
        schema_with_intercept,
        formula_with_intercept,
        num_array_columns_with_intercept,
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
