srand(999)

using StatsBase

num_rows = 1_000_000
labels_original = Vector{String}(num_rows)
sample!(
    ["red", "orange", "yellow", "green", "blue", "indigo", "violet"],
    labels_original;
    replace=true,
    )

labels_encoded1, label_decoding_map1 =
    AluthgeSinhaBase.encode_labels(labels_original, :integer)

labels_decoded1 = AluthgeSinhaBase.decode_labels(
    labels_encoded1,
    label_decoding_map1,
    )

@test( all( labels_original.==labels_decoded1 ) )

labels_encoded2, label_decoding_map2 =
    AluthgeSinhaBase.encode_labels(labels_original, :onehot)

labels_decoded2 = AluthgeSinhaBase.decode_labels(
    labels_encoded2,
    label_decoding_map2,
    )

@test( all( labels_original.==labels_decoded2 ) )

labels_encoded3, label_decoding_map3 =
    AluthgeSinhaBase.encode_labels(labels_original, :fullonehot)

labels_decoded3 = AluthgeSinhaBase.decode_labels(
    labels_encoded3,
    label_decoding_map3,
    )

@test( all( labels_original.==labels_decoded3 ) )

@test( AluthgeSinhaBase._onehotvector(5, 0) == [0, 0, 0, 0, 0] )
@test( AluthgeSinhaBase._onehotvector(5, 1) == [1, 0, 0, 0, 0] )
@test( AluthgeSinhaBase._onehotvector(5, 2) == [0, 1, 0, 0, 0] )
@test( AluthgeSinhaBase._onehotvector(5, 3) == [0, 0, 1, 0, 0] )
@test( AluthgeSinhaBase._onehotvector(5, 4) == [0, 0, 0, 1, 0] )
@test( AluthgeSinhaBase._onehotvector(5, 5) == [0, 0, 0, 0, 1] )
@test( AluthgeSinhaBase._onehotvector(5, 6) == [0, 0, 0, 0, 0] )
