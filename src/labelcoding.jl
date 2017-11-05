function encode_labels(
    uncoded_labels::AbstractVector,
    label_coding_map::Associative,
    )
    encoded_labels = [label_coding_map[x] for x = uncoded_labels]
    label_decoding_map = inverse(label_coding_map)
    return encoded_labels, label_decoding_map
end

function encode_labels(
    uncoded_labels::AbstractVector;
    indexing::Symbol=:zero,
    )
    label_coding_map = generate_label_coding_map(
        uncoded_labels;
        indexing=indexing,
        )
    return encode_labels(uncoded_labels, label_coding_map)
end

function generate_label_coding_map(
    uncoded_labels::AbstractVector{label_type},
    int_type::DataType = Int;
    indexing::Symbol=:zero,
    ) where label_type
    if !(int_type <: Integer)
        error("int_type must be a subtype of Integer")
    end
    if indexing == :zero
        index_offset = 0
    elseif indexing == :one
        index_offset = 1
    else
        error("indexing must be either :zero or :one")
    end
    label_coding_map = Dict{label_type, int_type}()
    unique_labels = unique(uncoded_labels)
    for i = 1:length(unique_labels)
        label_coding_map[unique_labels[i]] =
            int_type(i - 1 + index_offset)
    end
    return label_coding_map
end

function decode_labels(
    encoded_labels::AbstractVector,
    label_decoding_map::Associative,
    )
    return [label_decoding_map[x] for x = encoded_labels]
end
