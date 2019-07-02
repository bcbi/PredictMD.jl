function get_number_in_each_fold(num_samples::Integer, num_folds::Integer)::Vector{Int}
    if num_samples < num_folds
        throw(ArgumentError("`num_samples` must be greater than or equal to `num_folds`"))
    end
    result::Vector{Int} = zeros(Int, num_folds)
    if num_samples % num_folds == 0
        result .= Int(num_samples//num_folds)
    else
        min_number_per_fold = round(Int, floor(num_samples/num_folds))
        remaining_number = num_samples - min_number_per_fold*num_folds
        result[1:remaining_number] .= min_number_per_fold + 1
        result[(remaining_number+1):end] .= min_number_per_fold
    end
    @assert sum(result) == num_samples
    return result
end

function get_indices_in_each_fold(all_indices::AbstractVector{<:Integer}, num_folds::Integer)::Vector{Vector{Int}}
    all_indices_deepcopy = deepcopy(all_indices)
    unique!(all_indices_deepcopy)
    sort!(all_indices_deepcopy)
    num_samples = length(all_indices_deepcopy)
    number_in_each_fold = get_number_in_each_fold(num_samples, num_folds)
    result::Vector{Vector{Int}} = Vector{Vector{Int}}(undef, num_folds)
    lower::Int = 1
    upper::Int = lower + number_in_each_fold[1] - 1
    result[1] = all_indices_deepcopy[lower:upper]
    @assert length(result[1]) == length(unique(result[1]))
    @assert length(result[1]) == number_in_each_fold[1]
    for fold = 2:num_folds
        lower = upper + 1
        upper = lower + number_in_each_fold[fold] - 1
        result[fold] = all_indices_deepcopy[lower:upper]
        # @assert length(result[fold]) == length(unique(result[fold]))
        # @assert length(result[fold]) == number_in_each_fold[fold]
    end
    @assert all(sort(unique(all_indices_deepcopy)) .== sort(unique(vcat(result...))))
    return result
end

function get_leavein_indices(all_indices::AbstractVector{<:Integer}, num_folds::Integer, fold_choice::Integer)::Vector{Int}
    indices_in_each_fold::Vector{Vector{Int}} = get_indices_in_each_fold(all_indices, num_folds)
    result::Vector{Int} = reduce(vcat, indices_in_each_fold[(1:num_folds).!=fold_choice])
    return result
end

function get_leaveout_indices(all_indices::AbstractVector{<:Integer}, num_folds::Integer, fold_choice::Integer)::Vector{Int}
    indices_in_each_fold::Vector{Vector{Int}} = get_indices_in_each_fold(all_indices, num_folds)
    result::Vector{Int} = indices_in_each_fold[fold_choice]
    return result
end

function vector_to_ranges(vector::T1)::Vector{UnitRange{Int}} where
        T1 <: AbstractVector{T2} where
        T2 <: Integer
    result::Vector{UnitRange{Int}} = Vector{UnitRange{Int}}(undef, 0)
    vector_deepcopy = deepcopy(vector)
    unique!(vector_deepcopy)
    sort!(vector_deepcopy)
    if !isempty(vector_deepcopy)
        lower::Int = vector_deepcopy[1]
        upper::Int = vector_deepcopy[1]
        for x in vector_deepcopy
            if (x) > (upper + 1)
                push!(result, lower:upper)
                lower = x
                upper = x
            else
                upper = x
            end
        end
        push!(result, lower:upper)
    end
    unique!(result)
    sort!(result)
    return result
end

function ranges_to_vector(ranges::T1)::Vector{Int} where
        T1 <: AbstractVector{T2} where
        T2 <: AbstractRange{T3} where
        T3 <: Integer
    ranges_deepcopy = deepcopy(ranges)
    unique!(ranges_deepcopy)
    sort!(ranges_deepcopy)
    result = Vector{Int}(undef, 0)
    for r in ranges_deepcopy
        append!(result, collect(r))
    end
    unique!(result)
    sort!(result)
    return result
end

struct CrossValidation{T}
    leavein::Vector{CrossValidation{T}}
    leaveout::Vector{Vector{T}}
end

function Base.:(==)(x::CrossValidation{T}, y::CrossValidation{T})::Bool where T
   result::Bool = (x.leaveout == y.leaveout) && (x.leavein == y.leavein)
   return result
end

function CrossValidation{T}(
        ;
        num_folds_per_level,
        all_indices,
        )::CrossValidation{T} where T
    all_indices_deepcopy = deepcopy(all_indices)
    unique!(all_indices_deepcopy)
    sort!(all_indices_deepcopy)
    if length(num_folds_per_level) < 1
        leaveout = Vector{Vector{T}}(undef, 1)
        leaveout[1] = all_indices_deepcopy
        leavein = Vector{CrossValidation{T}}(undef, 0)
    else
        num_folds_this_level = num_folds_per_level[1]
        remaining_num_folds_per_level = num_folds_per_level[2:end]
        leaveout = Vector{Vector{T}}(undef, num_folds_this_level)
        leavein = Vector{CrossValidation{T}}(undef, num_folds_this_level)
        for fold_choice = 1:num_folds_this_level
            leaveout[fold_choice] = get_leaveout_indices(all_indices, num_folds_this_level, fold_choice)
            leavein[fold_choice] = CrossValidation{T}(
                ;
                num_folds_per_level = remaining_num_folds_per_level,
                all_indices = get_leavein_indices(all_indices, num_folds_this_level, fold_choice)
                )
        end
    end
    result::CrossValidation{T} = CrossValidation{T}(leavein, leaveout)
    return result
end

function CrossValidation{T}(
        cv::CrossValidation{R},
        )::CrossValidation{T} where
        T where
        R <: AbstractUnitRange{S} where
        S <: Integer
    if isleaf(cv)
        leaveout = Vector{Vector{T}}(undef, 1)
        leaveout[1] = ranges_to_vector(get_leavein_indices(cv))
        leavein = Vector{CrossValidation{T}}(undef, 0)
    else
        num_folds = get_top_level_num_folds(cv)
        leaveout = Vector{Vector{T}}(undef, num_folds)
        leavein = Vector{CrossValidation{T}}(undef, num_folds)
        for fold_choice = 1:num_folds
            leaveout[fold_choice] = ranges_to_vector(get_leaveout_indices(cv, fold_choice))
            leavein[fold_choice] = CrossValidation{T}(get_leavein_cv(cv, fold_choice))
        end
    end
    result::CrossValidation{T} = CrossValidation{T}(leavein, leaveout)
    return result
end

function CrossValidation{T}(
        cv::CrossValidation{<:Integer},
        )::CrossValidation{T} where T
    if isleaf(cv)
        leaveout = Vector{Vector{T}}(undef, 1)
        leaveout[1] = vector_to_ranges(get_leavein_indices(cv))
        leavein = Vector{CrossValidation{T}}(undef, 0)
    else
        num_folds = get_top_level_num_folds(cv)
        leaveout = Vector{Vector{T}}(undef, num_folds)
        leavein = Vector{CrossValidation{T}}(undef, num_folds)
        for fold_choice = 1:num_folds
            leaveout[fold_choice] = vector_to_ranges(get_leaveout_indices(cv, fold_choice))
            leavein[fold_choice] = CrossValidation{T}(get_leavein_cv(cv, fold_choice))
        end
    end
    result::CrossValidation{T} = CrossValidation{T}(leavein, leaveout)
    return result
end

function isleaf(cv::CrossValidation{T})::Bool where T
    result::Bool = length(cv.leavein) < 1
    return result
end

function get_leavein_cv(cv::CrossValidation{T}, fold_choice)::CrossValidation{T} where T
    if isleaf(cv)
        throw(ArgumentError("`cv` is a leaf, so `get_leavein_cv(cv, fold_choice)` is not defined"))
    end
    result::CrossValidation{T} = cv.leavein[fold_choice]
    return result
end

function get_leavein_indices(cv::CrossValidation{T})::Vector{T} where T
    if !isleaf(cv)
        throw(ArgumentError("`cv` is not a leaf, so `get_leavein_indices(cv)` is not defined"))
    end
    result::Vector{T} = cv.leaveout[1]
    return result
end

function get_leaveout_indices(cv::CrossValidation{T}, fold_choice)::Vector{T} where T
    if isleaf(cv)
        throw(ArgumentError("`cv` is a leaf, so `get_leaveout_indices(cv, fold_choice)` is not defined"))
    end
    result::Vector{T} = cv.leaveout[fold_choice]
    return result
end

function get_all_indices(cv::CrossValidation{T})::Vector{T} where T
    result::Vector{T} = sort(
        unique(
            reduce(vcat, cv.leaveout)
            )
        )
    return result
end

function get_top_level_num_folds(cv::CrossValidation{T})::Int where T
    if isleaf(cv)
        result = 0
    else
        if length(cv.leaveout) != length(cv.leavein)
            throw(DimensionMismatch("length(cv.leaveout) != length(cv.leavein)"))
        end
        result = length(cv.leaveout)
    end
    return result
end
