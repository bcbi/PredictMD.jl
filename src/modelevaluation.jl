using MLBase
using ScikitLearn

function performance(model::AbstractModel)
    return performance(STDOUT, model)
end

function performance(io::IO, model::AbstractModel)
    error("Not yet implemented for this model type.")
end

function performance(io::IO, model::AbstractSingleLabelBinaryClassifier)
    println(io, "Hi there!")
end
