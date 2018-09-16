import DataFrames

"""
"""
function fix_column_types!(
        df::DataFrames.AbstractDataFrame;
        categorical_feature_names::AbstractVector{Symbol} = Symbol[],
        continuous_feature_names::AbstractVector{Symbol} = Symbol[],
        categorical_label_names::AbstractVector{Symbol} = Symbol[],
        continuous_label_names::AbstractVector{Symbol} = Symbol[],
        float_type::Type{<:AbstractFloat} = Cfloat,
        )::Nothing
    function make_categorical_column(
            old_vector::AbstractVector,
            )::Vector{Any}
        new_vector = Vector{Any}(undef, length(old_vector))
        for i = 1:length(old_vector)
            old_vector_ith_element = old_vector[i]
            if DataFrames.ismissing(old_vector_ith_element)
                new_vector[i] = DataFrames.missing
            else
                new_vector[i] = string(old_vector_ith_element)
            end
        end
        return new_vector
    end
    function make_continuous_column(
            old_vector::AbstractVector,
            )::Vector{Any}
        new_vector = Vector{Any}(undef, length(old_vector))
        for i = 1:length(old_vector)
            old_vector_ith_element = old_vector[i]
            if DataFrames.ismissing(old_vector_ith_element)
                new_vector[i] = DataFrames.missing
            else
                new_vector[i] = float_type(old_vector_ith_element)
            end
        end
        return new_vector
    end
    for x in categorical_feature_names
        transform_columns!(df, make_categorical_column, x)
    end
    for x in continuous_feature_names
        transform_columns!(df, make_continuous_column, x)
    end
    for x in categorical_label_names
        transform_columns!(df, make_categorical_column, x)
    end
    for x in continuous_label_names
        transform_columns!(df, make_continuous_column, x)
    end
    for x in DataFrames.names(df)
        transform_columns!(df, fix_type, x)
    end
    return nothing
end

"""
"""
function check_column_types(
        df::DataFrames.AbstractDataFrame;
        categorical_feature_names::AbstractVector{Symbol} = Symbol[],
        continuous_feature_names::AbstractVector{Symbol} = Symbol[],
        categorical_label_names::AbstractVector{Symbol} = Symbol[],
        continuous_label_names::AbstractVector{Symbol} = Symbol[],
        )::Nothing
    for column_name in DataFrames.names(df)
        column_eltype=eltype(
            collect(
                DataFrames.skipmissing(
                    df[column_name]
                    )
                )
            )
        if column_name in categorical_feature_names
            if column_eltype<:AbstractString
            else
                error(
                    string(
                        "Column \"",
                        column_name,
                        "\" has eltype() \"",
                        column_eltype,
                        "\". However, this column is categorical,",
                        "and therefore its eltype() must be <: ",
                        "AbstractString.",
                        )
                    )
            end
        elseif column_name in categorical_label_names
            if column_eltype<:AbstractString
            else
                error(
                    string(
                        "Column \"",
                        column_name,
                        "\" has eltype() \"",
                        column_eltype,
                        "\". However, this column is categorical,",
                        "and therefore its eltype() must be <: ",
                        "AbstractString.",
                        )
                    )
            end
        elseif column_name in continuous_feature_names
            if column_eltype<:AbstractFloat
            else
                error(
                    string(
                        "Column \"",
                        column_name,
                        "\" has eltype() \"",
                        column_eltype,
                        "\". However, this column is continuous,",
                        "and therefore its eltype() must be <:",
                        "AbstractFloat.",
                        )
                    )
            end
        elseif column_name in continuous_label_names
            if column_eltype<:AbstractFloat
            else
                error(
                    string(
                        "Column \"",
                        column_name,
                        "\" has eltype() \"",
                        column_eltype,
                        "\". However, this column is continuous,",
                        "and therefore its eltype() must be <:",
                        "AbstractFloat.",
                        )
                    )
            end
        else
            if column_eltype<:AbstractString
            elseif column_eltype<:AbstractFloat
                error(
                    string(
                        "Column \"",
                        column_name,
                        "\" has eltype() \"",
                        column_eltype,
                        "\". However, we only allow AbstractStrings and ",
                        "AbstractFloats. Use T <: AbstractString if",
                        "it is a categorical column. Use T <: ",
                        "AbstractFloat if it is a continuous column."
                        )
                    )
            else
            end
        end
    end
    return nothing
end
