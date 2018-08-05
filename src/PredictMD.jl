##### Beginning of file

__precompile__(true)

"""
"""
module PredictMD # begin module PredictMD

############################################################################
# PredictMD base files (names here go in the top level namespace) ##########
############################################################################

# base/

include(joinpath(".", "base", "types.jl",)) # base/types.jl MUST go first

include(joinpath(".", "base", "init.jl",))
include(joinpath(".", "base", "interface.jl",))
include(joinpath(".", "base", "version.jl",))

############################################################################
# PredictMD source files (names here also go in the top level namespace) ###
############################################################################

# toplevel/calibration/

# toplevel/code_loading/
include(
    joinpath(
        ".", "toplevel", "code_loading", "requires.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "code_loading", "require_versions.jl",
        )
    )

# toplevel/compilation/
include(
    joinpath(
        ".", "toplevel", "compilation", "buildexecutable.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "compilation", "packagecompiler.jl",
        )
    )

# toplevel/classimbalance/
include(
    joinpath(
        ".", "toplevel", "classimbalance", "smote.jl",
        )
    )

# toplevel/cluster/

# toplevel/datasets/
include(
    joinpath(
        ".", "toplevel", "datasets", "csv.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "datadeps.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "gzip.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "juliadb.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "mldatasets.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "mnist.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "queryverse.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "datasets", "rdatasets.jl",
        )
    )

# toplevel/docs_and_examples/
include(
    joinpath(
        ".", "toplevel", "docs_and_examples", "generate_docs.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "docs_and_examples", "generate_examples.jl",
        )
    )

# toplevel/decomposition/

# toplevel/ensemble/

# toplevel/ide/
include(
    joinpath(
        ".", "toplevel", "ide", "atom.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "ide", "revise.jl",
        )
    )

# toplevel/io/
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
        ".", "toplevel", "linearmodel",
        "ordinary_least_squares_regression.jl",
        )
    )

# toplevel/metrics/
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
        ".", "toplevel", "metrics",
        "singlelabelbinaryclassificationmetrics.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "metrics", "singlelabelregressionmetrics.jl",
        )
    )

# toplevel/modelselection/
include(
    joinpath(
        ".", "toplevel", "modelselection", "split_data.jl",
        )
    )

# toplevel/multiclass/

# toplevel/multioutput/

# toplevel/neuralnetwork/
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
include(
    joinpath(
        ".", "toplevel", "neuralnetwork", "merlin.jl",
        )
    )
# toplevel/online/
include(
    joinpath(
        ".", "toplevel", "pipeline", "onlinestats.jl",
        )
    )

# toplevel/pipeline/
include(
    joinpath(
        ".", "toplevel", "pipeline", "simplelinearpipeline.jl",
        )
    )

# toplevel/plotting/

include(
    joinpath(
        ".", "toplevel", "plotting", "pgfplots.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "plotting", "pgfplotsx.jl",
        )
    )
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
        ".", "toplevel", "plotting",
        "plotsinglelabelregressiontruevspredicted.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "plotting",
        "plotsinglelabelbinaryclassifierhistograms.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "plotting",
        "probability_calibration_plots.jl",
        )
    )

# toplevel/postprocessing/
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

# toplevel/preprocessing/
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

# toplevel/svm/
include(
    joinpath(
        ".", "toplevel", "svm", "libsvm.jl",
        )
    )

# toplevel/tree/
include(
    joinpath(
        ".", "toplevel", "tree", "decisiontree.jl",
        )
    )

# toplevel/utils/
include(
    joinpath(
        ".", "toplevel", "utils", "filename_extension.jl",
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
        ".", "toplevel", "utils", "get_version_number.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "is_debug.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "labelstringintmaps.jl",
        )
    )
include(
    joinpath(
        ".", "toplevel", "utils", "make_directory.jl",
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
        ".", "toplevel", "utils", "pkg_dir.jl",
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

############################################################################
# PredictMD submodules (names here go in submodule namespaces) #############
############################################################################

# submodules/Clean/
include(
    joinpath(
        ".", "submodules", "Clean", "Clean.jl",
        )
    )

# submodules/GPU/
include(
    joinpath(
        ".", "submodules", "GPU", "GPU.jl",
        )
    )

a
# submodules/Server/
include(
    joinpath(
        ".", "submodules", "Server", "Server.jl",
        )
    )

end # end module PredictMD

##### End of file
