abstract type AbstractInterval end

struct NoBoundsInterval <: AbstractInterval
end

struct LowerAndUpperBoundInterval <: AbstractInterval
    left::String
    right::String
    function LowerAndUpperBoundInterval(
            left::String,
            right::String,
            )::LowerAndUpperBoundInterval
        correct_left = strip(left)
        correct_right = strip(right)
        result::LowerAndUpperBoundInterval = new(
            correct_left,
            correct_right,
            )
        return result
    end
end

struct LowerBoundOnlyInterval <: AbstractInterval
    left::String
    function LowerBoundOnlyInterval(
            left::String,
            )::LowerBoundOnlyInterval
        correct_left = strip(left)
        result::LowerBoundOnlyInterval = new(
            correct_left,
            )
        return result
    end
end

struct UpperBoundOnlyInterval <: AbstractInterval
    right::String
    function UpperBoundOnlyInterval(
            right::String,
            )::UpperBoundOnlyInterval
        correct_right = strip(right)
        result::UpperBoundOnlyInterval = new(
            correct_right,
            )
        return result
    end
end

function is_interval(x::String)::Bool
    if is_no_bounds_interval(x)
        return true
    elseif is_lower_bound_only_interval(x)
        return true
    elseif is_upper_bound_only_interval(x)
        return true
    elseif is_lower_and_upper_bound_interval(x)
        return true
    else
        return false
    end
end

function get_lower_and_upper_bound_interval_regex()::Regex
    lower_and_upper_bound_interval_regex::Regex =
        r"\[(\w\w*?)\,(\w\w*?)\)"
    return lower_and_upper_bound_interval_regex
end

function get_lower_bound_only_interval_regex()::Regex
    lower_bound_only_interval_regex::Regex =
        r"\[(\w\w*?)\,\)"
    return lower_bound_only_interval_regex
end

function get_upper_bound_only_interval_regex()::Regex
    upper_bound_only_interval_regex::Regex =
        r"\[\,(\w\w*?)\)"
    return upper_bound_only_interval_regex
end

function get_no_bounds_interval_regex()::Regex
    no_bounds_interval_regex::Regex =
        r"\[\,\)"
    return no_bounds_interval_regex
end

function is_no_bounds_interval(x::String)::Bool
    result::Bool = occursin(
        get_no_bounds_interval_regex(),
        x,
        )
    return result
end

function is_lower_and_upper_bound_interval(x::String)::Bool
    result::Bool = occursin(
        get_lower_and_upper_bound_interval_regex(),
        x,
        )
    return result
end

function is_lower_bound_only_interval(x::String)::Bool
    result::Bool = occursin(
        get_lower_bound_only_interval_regex(),
        x,
        )
    return result
end

function is_upper_bound_only_interval(x::String)::Bool
    result::Bool = occursin(
        get_upper_bound_only_interval_regex(),
        x,
        )
    return result
end

function construct_interval(x::String)::AbstractInterval
    if is_no_bounds_interval(x)
        result = NoBoundsInterval()
    elseif is_lower_bound_only_interval(x)
        loweronly_regexmatch::RegexMatch = match(
            get_lower_bound_only_interval_regex(),
            x,
            )
        loweronly_left::String = strip(
            convert(String, loweronly_regexmatch[1])
            )
        result = LowerBoundOnlyInterval(loweronly_left)
    elseif is_upper_bound_only_interval(x)
        upperonly_regexmatch::RegexMatch = match(
            get_upper_bound_only_interval_regex(),
            x,
            )
        upperonly_right::String = strip(
            convert(String, upperonly_regexmatch[1])
            )
        result = UpperBoundOnlyInterval(upperonly_right)
    elseif is_lower_and_upper_bound_interval(x)
        lowerandupper_regexmatch::RegexMatch = match(
            get_lower_and_upper_bound_interval_regex(),
            x,
            )
        lowerandupper_left::String = strip(
            convert(String, lowerandupper_regexmatch[1])
            )
        lowerandupper_right::String = strip(
            convert(String, lowerandupper_regexmatch[2])
            )
        result = LowerAndUpperBoundInterval(
            lowerandupper_left,
            lowerandupper_right,
            )
    else
        delayederror("argument is not a valid interval")
    end
    return result
end

function interval_contains_x(
        interval::NoBoundsInterval,
        x::AbstractString,
        )::Bool
    result::Bool = true
    return result
end

function interval_contains_x(
        interval::LowerAndUpperBoundInterval,
        x::AbstractString,
        )::Bool
    x_stripped::String = strip(convert(String, x))
    left::String = strip(interval.left)
    right::String = strip(interval.right)
    result::Bool = (left <= x_stripped) && (x_stripped < right)
    return result
end

function interval_contains_x(
        interval::LowerBoundOnlyInterval,
        x::AbstractString,
        )::Bool
    x_stripped::String = strip(convert(String, x))
    left::String = strip(interval.left)
    result::Bool = left <= x_stripped
    return result
end

function interval_contains_x(
        interval::UpperBoundOnlyInterval,
        x::AbstractString,
        )
    x_stripped::String = strip(convert(String, x))
    right::String = strip(interval.right)
    result::Bool = x_stripped < right
    return result
end
