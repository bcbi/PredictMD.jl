srand(999)

using StatsBase

num_rows = 1_000_000
labels_original = Vector{String}(num_rows)
sample!(
    ["red", "orange", "yellow", "green", "blue", "indigo", "violet"],
    labels_original;
    replace=true,
    )

labels_encoded, label_decoding_map =
    AluthgeSinhaBase.encode_labels(labels_original)

labels_decoded = AluthgeSinhaBase.decode_labels(
    labels_encoded,
    label_decoding_map,
    )

@test( all( labels_original.==labels_decoded ) )
