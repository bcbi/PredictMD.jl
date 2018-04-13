import DataFrames

struct DataFrameContrasts <: Contrasts
    columns::T1 where T1 <: SymbolVector
    num_df_columns::T2 where T2 <: Integer
    contrasts::T3 where T3 <: Associative
    numarraycolumns::T4 where T4 <: Integer
end

function DataFrameContrasts(
        df::DataFrames.AbstractDataFrame,
        columns::SymbolVector,
        )
    num_df_columns = length(unique(columns))
    modelformula = makeformula(
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
    numarraycolumns = size(columnsarray, 2)
    result = DataFrameContrasts(
        columns,
        num_df_columns,
        contrasts,
        numarraycolumns,
        )
    return result
end

contrasts(df::DataFrames.AbstractDataFrame,columns::SymbolVector) =
    DataFrameContrasts(df,columns)
