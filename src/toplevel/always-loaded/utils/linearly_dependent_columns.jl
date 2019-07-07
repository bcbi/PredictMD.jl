import DataFrames
import GLM
import StatsModels

function get_unique_symbol_name(
        v::AbstractVector{<:Symbol},
        new_symbol::Symbol = :x;
        append_string::String = "1"
        )::Symbol
    old_strings_set::Set{String} = Set(strip.(string.(v)))
    new_string::String = strip.(string.(new_symbol))
    _append_string::String = strip(append_string)
    while new_string in old_strings_set
        new_string = string(new_string, _append_string)
    end
    new_symbol::Symbol = Symbol(new_string)
    return new_symbol
end

function columns_are_linearly_independent(
        df::DataFrames.DataFrame,
        columns::AbstractVector{<:Symbol} = Symbol[],
        )::Bool
    df_copy = deepcopy(df)
    if length(columns) == 0
        columns_copy = deepcopy(DataFrames.names(df_copy))
    else
        columns_copy = deepcopy(columns)
    end
    temporary_dependent_variable::Symbol = get_unique_symbol_name(
        columns_copy,
        :y,
        )
    formula = generate_formula(
        temporary_dependent_variable,
        columns_copy;
        intercept = false,
        interactions = 1,
        )
    df_copy[temporary_dependent_variable] = randn(size(df_copy, 1))
    try_lm_result::Bool = try
        lm = GLM.lm(formula, df_copy, false)
        true
    catch ex
        @debug("caught exception: ", exception=ex,)
        false
    end
    cols_result = length(linearly_dependent_columns(df, columns)) == 0
    final_result::Bool = try_lm_result && cols_result
    return final_result
end

function linearly_dependent_columns(
        df::DataFrames.DataFrame,
        columns::AbstractVector{<:Symbol} = Symbol[])::Vector{Symbol}
    df_copy = deepcopy(df)
    if length(columns) == 0
        columns_copy = deepcopy(DataFrames.names(df_copy))
    else
        columns_copy = deepcopy(columns)
    end
    temporary_dependent_variable::Symbol = get_unique_symbol_name(
        columns_copy,
        :y,
        )
    formula = generate_formula(
        temporary_dependent_variable,
        columns_copy;
        intercept = false,
        interactions = 1,
        )
    df_copy[temporary_dependent_variable] = randn(size(df_copy, 1))
    lm = GLM.lm(formula, df_copy, true)
    coeftable = StatsModels.coeftable(lm)
    result_strings::Vector{String} = sort(
        unique(strip.(coeftable.rownms[isnan.(coeftable.cols[4])]))
        )
    result_symbols::Vector{Symbol} = Symbol.(result_strings)
    return result_symbols
end
