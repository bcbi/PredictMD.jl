function DataTableRegressionModel_to_DataFrameRegressionModel(
        x::StatsModels.DataTableRegressionModel
        )
    result = DataFrames.DataFrameRegressionModel(
        x.model,
        x.mf,
        x.mm,
        )
    return result
end
