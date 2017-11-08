function encode_labels(
    uncoded_labels::AbstractVector,
    label_encoding_map::Associative,
    )
    if eltype(collect(values(label_encoding_map))) <: Integer
        encoded_labels = [label_encoding_map[x] for x = uncoded_labels]
    else
        num_rows = length(uncoded_labels)
        num_columns = length(collect(values(label_encoding_map))[1])
        int_type = eltype(collect(values(label_encoding_map))[1])
        encoded_labels = -99 * ones(int_type, num_rows, num_columns)
        for i = 1:num_rows
            encoded_labels[i, :] = label_encoding_map[uncoded_labels[i]]
        end
    end
    label_decoding_map = inverse(label_encoding_map)
    return encoded_labels, label_decoding_map
end


function encode_labels(
    uncoded_labels::AbstractVector,
    method::Symbol,
    int_type::DataType = Int,
    )
    label_encoding_map = generate_label_encoding_map(
        uncoded_labels,
        method,
        int_type,
        )
    return encode_labels(uncoded_labels, label_encoding_map)
end

function generate_label_encoding_map(
    uncoded_labels::AbstractVector{label_type},
    method::Symbol,
    int_type::DataType = Int,
    ) where label_type
    if !(
            method in [
                :integer,
                :integer_zeroindexed,
                :integer_oneindexed,
                :onehot,
                :dummy,
                :fullonehot,
                :fulldummy
                ]
            )
        error("\"$(method)\" is not a supported label coding method.")
    end
    if !(int_type <: Integer)
        error("int_type must be a subtype of Integer")
    end
    if (method in [:integer, :integer_zeroindexed, :integer_oneindexed])
        label_encoding_map = Dict{label_type, int_type}()
    else
        label_encoding_map = Dict{label_type, Vector{int_type}}()
    end

    unique_labels = unique(uncoded_labels)
    num_unique_labels = length(unique_labels)

    if (method in [:integer, :integer_zeroindexed, :integer_oneindexed])
        num_columns_needed = 1
    elseif (method == :onehot || method == :dummy)
        num_columns_needed = num_unique_labels - 1
    elseif (method == :fullonehot || method == :fulldummy)
        num_columns_needed = num_unique_labels
    else
    end

    if (method == :integer || method == :integer_zeroindexed)
        for i = 1:num_unique_labels
            label_encoding_map[unique_labels[i]] = int_type(i - 1)
        end
    elseif method == :integer_oneindexed
        for i = 1:num_unique_labels
            label_encoding_map[unique_labels[i]] = int_type(i)
        end
    elseif (method == :onehot || method == :dummy)
        for i = 1:num_unique_labels
            label_encoding_map[unique_labels[i]] = _onehotvector(
                num_columns_needed,
                i - 1,
                int_type,
                )
        end

    elseif (method == :fullonehot || method == :fulldummy)
        for i = 1:num_unique_labels
            label_encoding_map[unique_labels[i]] = _onehotvector(
                num_columns_needed,
                i,
                int_type,
                )
        end
    end
    return label_encoding_map
end

function _onehotvector(
        length::Integer,
        position::Integer,
        int_type::DataType = Int,
        )
    result = zeros(int_type, length)
    if 1 <= position <= length
        result[position] = 1
    end
    return result
end

function decode_labels(
    encoded_labels::AbstractVector,
    label_decoding_map::Associative,
    )
    return [label_decoding_map[x] for x = encoded_labels]
end

function decode_labels(
    encoded_labels::AbstractMatrix,
    label_decoding_map::Associative,
    )
    num_rows = size(encoded_labels, 1)
    return [label_decoding_map[encoded_labels[i,:]] for i = 1:num_rows]
end
