__precompile__(true)

"""
"""
module PredictMD

##############################################################################
# Top level ##################################################################
##############################################################################

# base/
# (base must go first)
include(
    joinpath(
        ".", "base", "interface.jl",
        )
    )
include(
    joinpath(
        ".", "base", "types.jl",
        )
    )
include(
    joinpath(
        ".", "base", "version.jl",
        )
    )

# deprecations/
# (deprecations must go second)
include(
    joinpath(
        ".", "deprecations", "deprecated.jl",
        )
    )

# calibration/

# classimbalance/
include(
    joinpath(
        ".", "classimbalance", "smote.jl",
        )
    )

# cluster/

# datasets/
include(
    joinpath(
        ".", "datasets", "csv.jl",
        )
    )
include(
    joinpath(
        ".", "datasets", "gzip.jl",
        )
    )
include(
    joinpath(
        ".", "datasets", "rdatasets.jl",
        )
    )


# decomposition/

# ensemble/

# integrations/
include(
    joinpath(
        ".", "integrations", "ide", "atom.jl",
        )
    )
include(
    joinpath(
        ".", "integrations", "literate_programming", "literate.jl",
        )
    )
include(
    joinpath(
        ".", "integrations", "literate_programming", "weave.jl",
        )
    )


# io/
include(
    joinpath(
        ".", "io", "saveload.jl",
        )
    )

# linearmodel/
include(
    joinpath(
        ".", "linearmodel", "glm.jl",
        )
    )
include(
    joinpath(
        ".", "linearmodel", "ordinary_least_squares_regression.jl",
        )
    )

# metrics/
include(
    joinpath(
        ".", "metrics", "auprc.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "aurocc.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "averageprecisionscore.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "brier_score.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "coefficientofdetermination.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "cohenkappa.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "getbinarythresholds.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "mean_square_error.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "prcurve.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "risk_score_cutoff_values.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "roccurve.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "rocnumsmetrics.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "singlelabelbinaryclassificationmetrics.jl",
        )
    )
include(
    joinpath(
        ".", "metrics", "singlelabelregressionmetrics.jl",
        )
    )


# modelselection/
include(
    joinpath(
        ".", "modelselection", "split_data.jl",
        )
    )

# multiclass/

# multioutput/

# neuralnetwork/
include(
    joinpath(
        ".", "neuralnetwork", "flux.jl",
        )
    )
include(
    joinpath(
        ".", "neuralnetwork", "knet.jl",
        )
    )

# pipeline/
include(
    joinpath(
        ".", "pipeline", "simplelinearpipeline.jl",
        )
    )

# plotting/

include(
    joinpath(
        ".", "plotting", "plotlearningcurve.jl",
        )
    )
include(
    joinpath(
        ".", "plotting", "plotprcurve.jl",
        )
    )
include(
    joinpath(
        ".", "plotting", "plotroccurve.jl",
        )
    )
include(
    joinpath(
        ".", "plotting", "plotsinglelabelregressiontruevspredicted.jl",
        )
    )
include(
    joinpath(
        ".", "plotting", "plotsinglelabelbinaryclassifierhistograms.jl",
        )
    )
include(
    joinpath(
        ".", "plotting", "probability_calibration_plots.jl",
        )
    )

# postprocessing/
include(
    joinpath(
        ".", "postprocessing", "packagemultilabelpred.jl",
        )
    )
include(
    joinpath(
        ".", "postprocessing", "packagesinglelabelpred.jl",
        )
    )
include(
    joinpath(
        ".", "postprocessing", "packagesinglelabelproba.jl",
        )
    )
include(
    joinpath(
        ".", "postprocessing", "predictoutput.jl",
        )
    )
include(
    joinpath(
        ".", "postprocessing", "predictprobaoutput.jl",
        )
    )

# preprocessing/
include(
    joinpath(
        ".", "preprocessing", "dataframecontrasts.jl",
        )
    )
include(
    joinpath(
        ".", "preprocessing", "dataframetodecisiontree.jl",
        )
    )
include(
    joinpath(
        ".", "preprocessing", "dataframetoglm.jl",
        )
    )
include(
    joinpath(
        ".", "preprocessing", "dataframetoknet.jl",
        )
    )
include(
    joinpath(
        ".", "preprocessing", "dataframetosvm.jl",
        )
    )

# svm/
include(
    joinpath(
        ".", "svm", "libsvm.jl",
        )
    )

# tree/
include(
    joinpath(
        ".", "tree", "decisiontree.jl",
        )
    )

# utils/
include(
    joinpath(
        ".", "utils", "file_exists.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "fix_dict_type.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "fix_vector_type.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "formulas.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "labelstringintmaps.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "missings.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "nothings.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "openbrowserwindow.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "openplotsduringtestsenv.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "predictionsassoctodataframe.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "probabilitiestopredictions.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "runtestsenv.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "shufflerows.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "simplemovingaverage.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "tikzpictures.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "trapz.jl",
        )
    )
include(
    joinpath(
        ".", "utils", "traviscienv.jl",
        )
    )


##############################################################################
# Submodules #################################################################
##############################################################################

# submodules/clean/
include(
    joinpath(
        ".", "submodules", "clean", "clean.jl",
        )
    )

# submodules/gpu/
include(
    joinpath(
        ".", "submodules", "gpu", "gpu.jl",
        )
    )

end # end module PredictMD
