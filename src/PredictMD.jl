__precompile__(true)

"""
"""
module PredictMD # begin module PredictMD

using Distributed
using Random

include("package_directory.jl")
include("registry_url_list.jl")
include("version.jl")
include("version_codename.jl")
include("welcome.jl")
include("init.jl")

include("base/abstract-types.jl")
include("base/concrete-types.jl")
include("base/interface.jl")
include("base/backends.jl")
include("base/next_version_number.jl")

include("toplevel/code_loading/requires.jl")
include("toplevel/code_loading/require_versions.jl")

include("toplevel/classimbalance/smote.jl")


include("toplevel/datasets/csv.jl")
include("toplevel/datasets/datadeps.jl")
include("toplevel/datasets/gzip.jl")
include("toplevel/datasets/juliadb.jl")
include("toplevel/datasets/mldatasets.jl")
include("toplevel/datasets/mnist.jl")
include("toplevel/datasets/queryverse.jl")
include("toplevel/datasets/rdatasets.jl")


include("toplevel/docs_and_examples/cache.jl")
include("toplevel/docs_and_examples/generate_examples.jl")


include("toplevel/ide/atom.jl")
include("toplevel/ide/revise.jl")
include("toplevel/io/saveload.jl")

include("toplevel/linearmodel/glm.jl")
include("toplevel/linearmodel/ordinary_least_squares_regression.jl")

include("toplevel/metrics/auprc.jl")
include("toplevel/metrics/aurocc.jl")
include("toplevel/metrics/averageprecisionscore.jl")
include("toplevel/metrics/brier_score.jl")
include("toplevel/metrics/coefficientofdetermination.jl")
include("toplevel/metrics/cohenkappa.jl")
include("toplevel/metrics/getbinarythresholds.jl")
include("toplevel/metrics/mean_square_error.jl")
include("toplevel/metrics/prcurve.jl")
include("toplevel/metrics/risk_score_cutoff_values.jl")
include("toplevel/metrics/roccurve.jl")
include("toplevel/metrics/rocnumsmetrics.jl")
include("toplevel/metrics/singlelabelbinaryclassificationmetrics.jl")
include("toplevel/metrics/singlelabelregressionmetrics.jl")

include("toplevel/modelselection/split_data.jl")


include("toplevel/neuralnetwork/flux.jl")
include("toplevel/neuralnetwork/knet.jl")
include("toplevel/neuralnetwork/merlin.jl")


include("toplevel/online/onlinestats.jl")

include("toplevel/ontologies/ccs.jl")

include("toplevel/pipeline/simplelinearpipeline.jl")



include("toplevel/plotting/catch_plotting_errors.jl")
include("toplevel/plotting/defaultapplication.jl")
include("toplevel/plotting/pgfplots.jl")
include("toplevel/plotting/pgfplotsx.jl")
include("toplevel/plotting/plotlearningcurve.jl")
include("toplevel/plotting/plotprcurve.jl")
include("toplevel/plotting/plotroccurve.jl")
include("toplevel/plotting/plotsinglelabelregressiontruevspredicted.jl")
include("toplevel/plotting/plotsinglelabelbinaryclassifierhistograms.jl")
include("toplevel/plotting/probability_calibration_plots.jl")
include("toplevel/plotting/unicodeplots.jl")

include("toplevel/postprocessing/packagemultilabelpred.jl")
include("toplevel/postprocessing/packagesinglelabelpred.jl")
include("toplevel/postprocessing/packagesinglelabelproba.jl")
include("toplevel/postprocessing/predictoutput.jl")
include("toplevel/postprocessing/predictprobaoutput.jl")

include("toplevel/preprocessing/dataframecontrasts.jl")
include("toplevel/preprocessing/dataframetodecisiontree.jl")
include("toplevel/preprocessing/dataframetoglm.jl")
include("toplevel/preprocessing/dataframetoknet.jl")
include("toplevel/preprocessing/dataframetosvm.jl")

include("toplevel/svm/libsvm.jl")

include("toplevel/time_series/timeseries.jl")

include("toplevel/tree/decisiontree.jl")

include("toplevel/utils/constant_columns.jl")
include("toplevel/utils/dataframe_column_types.jl")
include("toplevel/utils/filename_extension.jl")
include("toplevel/utils/find.jl")
include("toplevel/utils/fix_type.jl")
include("toplevel/utils/formulas.jl")
include("toplevel/utils/inverse-dictionary.jl")
include("toplevel/utils/is_debug.jl")
include("toplevel/utils/labelstringintmaps.jl")
include("toplevel/utils/linearly_dependent_columns.jl")
include("toplevel/utils/make_directory.jl")
include("toplevel/utils/maketemp.jl")
include("toplevel/utils/missings.jl")
include("toplevel/utils/nothings.jl")
include("toplevel/utils/openbrowserwindow.jl")
include("toplevel/utils/openplotsduringtestsenv.jl")
include("toplevel/utils/predictionsassoctodataframe.jl")
include("toplevel/utils/probabilitiestopredictions.jl")
include("toplevel/utils/runtestsenv.jl")
include("toplevel/utils/shufflerows.jl")
include("toplevel/utils/simplemovingaverage.jl")
include("toplevel/utils/tikzpictures.jl")
include("toplevel/utils/transform_columns.jl")
include("toplevel/utils/trapz.jl")
include("toplevel/utils/traviscienv.jl")
include("toplevel/utils/tuplify.jl")

include("submodules/Cleaning/Cleaning.jl")
include("submodules/Compilation/Compilation.jl")
include("submodules/GPU/GPU.jl")
include("submodules/Server/Server.jl")

end # end module PredictMD
