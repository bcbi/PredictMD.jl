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

# calibration/

# classimbalance/
include(
    joinpath(
        ".", "toplevel", "classimbalance", "smote.jl",
        )
    )

# cluster/

# datasets/
include(
    joinpath(
        ".", "toplevel", "datasets", "csv.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "gzip.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "rdatasets.jl",
        )
    )


# decomposition/

# ensemble/

# integrations/
include(
    joinpath(
        ".", "toplevel", "integrations", "ide", "atom.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "integrations", "literate_programming", "literate.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "integrations", "literate_programming", "weave.jl",
        )
    )


# io/
include(
    joinpath(
        ".", "toplevel", "io", "saveload.jl",
        )
    )

# linearmodel/
include(
    joinpath(
        ".", "toplevel", "linearmodel", "glm.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "linearmodel", "ordinary_least_squares_regression.jl",
        )
    )

# metrics/
include(
    joinpath(
        ".", "toplevel", "metrics", "auprc.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "aurocc.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "averageprecisionscore.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "brier_score.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "coefficientofdetermination.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "cohenkappa.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "getbinarythresholds.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "mean_square_error.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "prcurve.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "risk_score_cutoff_values.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "roccurve.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "rocnumsmetrics.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "singlelabelbinaryclassificationmetrics.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "singlelabelregressionmetrics.jl",
        )
    )


# modelselection/
include(
    joinpath(
        ".", "toplevel", "modelselection", "split_data.jl",
        )
    )

# multiclass/

# multioutput/

# neuralnetwork/
include(
    joinpath(
        ".", "toplevel", "neuralnetwork", "flux.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "neuralnetwork", "knet.jl",
        )
    )

# pipeline/
include(
    joinpath(
        ".", "toplevel", "pipeline", "simplelinearpipeline.jl",
        )
    )

# plotting/

include(
    joinpath(
        ".", "toplevel", "plotting", "plotlearningcurve.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "plotting", "plotprcurve.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "plotting", "plotroccurve.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "plotting", "plotsinglelabelregressiontruevspredicted.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "plotting", "plotsinglelabelbinaryclassifierhistograms.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "plotting", "probability_calibration_plots.jl",
        )
    )

# postprocessing/
include(
    joinpath(
        ".", "toplevel", "postprocessing", "packagemultilabelpred.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "postprocessing", "packagesinglelabelpred.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "postprocessing", "packagesinglelabelproba.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "postprocessing", "predictoutput.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "postprocessing", "predictprobaoutput.jl",
        )
    )

# preprocessing/
include(
    joinpath(
        ".", "toplevel", "preprocessing", "dataframecontrasts.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "preprocessing", "dataframetodecisiontree.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "preprocessing", "dataframetoglm.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "preprocessing", "dataframetoknet.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "preprocessing", "dataframetosvm.jl",
        )
    )

# svm/
include(
    joinpath(
        ".", "toplevel", "svm", "libsvm.jl",
        )
    )

# tree/
include(
    joinpath(
        ".", "toplevel", "tree", "decisiontree.jl",
        )
    )

# utils/
include(
    joinpath(
        ".", "toplevel", "utils", "file_exists.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "fix_dict_type.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "fix_vector_type.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "formulas.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "labelstringintmaps.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "missings.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "nothings.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "openbrowserwindow.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "openplotsduringtestsenv.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "predictionsassoctodataframe.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "probabilitiestopredictions.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "runtestsenv.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "shufflerows.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "simplemovingaverage.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "tikzpictures.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "trapz.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "traviscienv.jl",
        )
    )


##############################################################################
# Submodules #################################################################
##############################################################################

# submodules/clean/
include(
    joinpath(
        ".", "submodules", "clean", "Clean.jl",
        )
    )

# submodules/gpu/
include(
    joinpath(
        ".", "submodules", "gpu", "GPU.jl",
        )
    )

end # end module PredictMD
