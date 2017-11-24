struct Ensemble{M} <: AbstractEnsemble{M}
    blobs::A where A <: Associative
end
