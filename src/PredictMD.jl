##### Beginning of file

__precompile__(true)

"""
"""
module PredictMD # begin module PredictMD

using Distributed
using Random

include(joinpath("package_directory.jl"))
include(joinpath("registry_url_list.jl"))
include(joinpath("version.jl"))
include(joinpath("welcome.jl"))
include(joinpath("init.jl"))

############################################################################
# PredictMD base files (names here go in the top level namespace) ##########
############################################################################

# base/

include(joinpath("base", "abstract-types.jl",))
include(joinpath("base", "concrete-types.jl",))
include(joinpath("base", "backends.jl",))

include(joinpath("base", "next_version_number.jl",))
include(joinpath("base", "interface.jl",))

############################################################################
# PredictMD source files (names here also go in the top level namespace) ###
############################################################################

# toplevel/calibration/

# toplevel/code_loading/
include(
    joinpath(
        "toplevel", "code_loading", "requires.jl",
        )
    )
include(
    joinpath(
        "toplevel", "code_loading", "require_versions.jl",
        )
    )

# toplevel/classimbalance/
include(
    joinpath(
        "toplevel", "classimbalance", "smote.jl",
        )
    )

# toplevel/cluster/

# toplevel/datasets/
include(
    joinpath(
        "toplevel", "datasets", "csv.jl",
        )
    )
include(
    joinpath(
        "toplevel", "datasets", "datadeps.jl",
        )
    )
include(
    joinpath(
        "toplevel", "datasets", "gzip.jl",
        )
    )
include(
    joinpath(
        "toplevel", "datasets", "juliadb.jl",
        )
    )
include(
    joinpath(
        "toplevel", "datasets", "mldatasets.jl",
        )
    )
include(
    joinpath(
        "toplevel", "datasets", "mnist.jl",
        )
    )
include(
    joinpath(
        "toplevel", "datasets", "queryverse.jl",
        )
    )
include(
    joinpath(
        "toplevel", "datasets", "rdatasets.jl",
        )
    )

# toplevel/docs_and_examples/
include(
    joinpath(
        "toplevel", "docs_and_examples", "generate_examples.jl",
        )
    )
include(
    joinpath(
        "toplevel", "docs_and_examples", "cache.jl",
        )
    )

# toplevel/decomposition/

# toplevel/ensemble/

# toplevel/ide/
include(
    joinpath(
        "toplevel", "ide", "atom.jl",
        )
    )
include(
    joinpath(
        "toplevel", "ide", "revise.jl",
        )
    )

# toplevel/io/
include(
    joinpath(
        "toplevel", "io", "saveload.jl",
        )
    )

# linearmodel/
include(
    joinpath(
        "toplevel", "linearmodel", "glm.jl",
        )
    )
include(
    joinpath(
        "toplevel", "linearmodel",
        "ordinary_least_squares_regression.jl",
        )
    )

# toplevel/metrics/
include(
    joinpath(
        "toplevel", "metrics", "auprc.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "aurocc.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "averageprecisionscore.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "brier_score.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "coefficientofdetermination.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "cohenkappa.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "getbinarythresholds.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "mean_square_error.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "prcurve.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "risk_score_cutoff_values.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "roccurve.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "rocnumsmetrics.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics",
        "singlelabelbinaryclassificationmetrics.jl",
        )
    )
include(
    joinpath(
        "toplevel", "metrics", "singlelabelregressionmetrics.jl",
        )
    )

# toplevel/modelselection/
include(
    joinpath(
        "toplevel", "modelselection", "split_data.jl",
        )
    )

# toplevel/multiclass/

# toplevel/multioutput/

# toplevel/neuralnetwork/
include(
    joinpath(
        "toplevel", "neuralnetwork", "flux.jl",
        )
    )
include(
    joinpath(
        "toplevel", "neuralnetwork", "knet.jl",
        )
    )
include(
    joinpath(
        "toplevel", "neuralnetwork", "merlin.jl",
        )
    )

# toplevel/online/
include(
    joinpath(
        "toplevel", "online", "onlinestats.jl",
        )
    )

# toplevel/ontologies/
include(
    joinpath(
        "toplevel", "ontologies", "ccs.jl",
        )
    )

# toplevel/pipeline/
include(
    joinpath(
        "toplevel", "pipeline", "simplelinearpipeline.jl",
        )
    )

# toplevel/plotting/
include(
    joinpath(
        "toplevel", "plotting", "catch_plotting_errors.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting", "defaultapplication.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting", "pgfplots.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting", "pgfplotsx.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting", "plotlearningcurve.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting", "plotprcurve.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting", "plotroccurve.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting",
        "plotsinglelabelregressiontruevspredicted.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting",
        "plotsinglelabelbinaryclassifierhistograms.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting",
        "probability_calibration_plots.jl",
        )
    )
include(
    joinpath(
        "toplevel", "plotting",
        "unicodeplots.jl",
        )
    )

# toplevel/postprocessing/
include(
    joinpath(
        "toplevel", "postprocessing", "packagemultilabelpred.jl",
        )
    )
include(
    joinpath(
        "toplevel", "postprocessing", "packagesinglelabelpred.jl",
        )
    )
include(
    joinpath(
        "toplevel", "postprocessing", "packagesinglelabelproba.jl",
        )
    )
include(
    joinpath(
        "toplevel", "postprocessing", "predictoutput.jl",
        )
    )
include(
    joinpath(
        "toplevel", "postprocessing", "predictprobaoutput.jl",
        )
    )

# toplevel/preprocessing/
include(
    joinpath(
        "toplevel", "preprocessing", "dataframecontrasts.jl",
        )
    )
include(
    joinpath(
        "toplevel", "preprocessing", "dataframetodecisiontree.jl",
        )
    )
include(
    joinpath(
        "toplevel", "preprocessing", "dataframetoglm.jl",
        )
    )
include(
    joinpath(
        "toplevel", "preprocessing", "dataframetoknet.jl",
        )
    )
include(
    joinpath(
        "toplevel", "preprocessing", "dataframetosvm.jl",
        )
    )

# toplevel/svm/
include(
    joinpath(
        "toplevel", "svm", "libsvm.jl",
        )
    )

# toplevel/time_series/
include(
    joinpath(
        "toplevel", "time_series", "timeseries.jl",
        )
    )

# toplevel/tree/
include(
    joinpath(
        "toplevel", "tree", "decisiontree.jl",
        )
    )

# toplevel/utils/
include(
    joinpath(
        "toplevel", "utils", "constant_columns.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "dataframe_column_types.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "filename_extension.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "find.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "fix_type.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "formulas.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "inverse-dictionary.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "is_debug.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "labelstringintmaps.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "make_directory.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "missings.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "nothings.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "openbrowserwindow.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "openplotsduringtestsenv.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "predictionsassoctodataframe.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "probabilitiestopredictions.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "runtestsenv.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "shufflerows.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "simplemovingaverage.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "tikzpictures.jl",
        )
    )

include(
    joinpath(
        "toplevel", "utils", "transform_columns.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "trapz.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "traviscienv.jl",
        )
    )
include(
    joinpath(
        "toplevel", "utils", "tuplify.jl",
        )
    )

############################################################################
# PredictMD submodules (names here go in submodule namespaces) #############
############################################################################

# PredictMD.Cleaning submodule
# submodules/Cleaning/
include(
    joinpath(
        "submodules", "Cleaning", "Cleaning.jl",
        )
    )

# PredictMD.Compilation submodule
# submodules/Compilation/
include(
    joinpath(
        "submodules", "Compilation", "Compilation.jl",
        )
    )

# PredictMD.GPU submodule
# submodules/GPU/
include(
    joinpath(
        "submodules", "GPU", "GPU.jl",
        )
    )

# PredictMD.Server submodule
# submodules/Server/
include(
    joinpath(
        "submodules", "Server", "Server.jl",
        )
    )

end # end module PredictMD

##### End of file
