__precompile__(true)

"""
"""
module PredictMD # begin module PredictMD

import Distributed
import Random

include("base/api.jl")

include("base/backends.jl")
include("base/concrete-types.jl")
include("base/fallback.jl")

include("registry_url_list.jl")
include("package_directory.jl")
include("version.jl")
include("version_codename.jl")
include("package_list.jl")
include("import_all.jl")
include("welcome.jl")
include("init.jl")

include("toplevel/always-loaded/code_loading/requires.jl")
include("toplevel/always-loaded/code_loading/require_versions.jl")

include("toplevel/always-loaded/classimbalance/smote.jl")

include("toplevel/always-loaded/datasets/csv.jl")
include("toplevel/always-loaded/datasets/datadeps.jl")
include("toplevel/always-loaded/datasets/gzip.jl")
include("toplevel/always-loaded/datasets/juliadb.jl")
include("toplevel/always-loaded/datasets/mldatasets.jl")
include("toplevel/always-loaded/datasets/mnist.jl")
include("toplevel/always-loaded/datasets/queryverse.jl")
include("toplevel/always-loaded/datasets/rdatasets.jl")

include("toplevel/always-loaded/docs_and_examples/cache.jl")
include("toplevel/always-loaded/docs_and_examples/generate_examples.jl")

include("toplevel/always-loaded/ide/atom.jl")

include("toplevel/always-loaded/io/saveload.jl")

include("toplevel/always-loaded/linearmodel/glm.jl")
include("toplevel/always-loaded/linearmodel/ordinary_least_squares_regression.jl")

include("toplevel/always-loaded/metrics/auprc.jl")
include("toplevel/always-loaded/metrics/aurocc.jl")
include("toplevel/always-loaded/metrics/averageprecisionscore.jl")
include("toplevel/always-loaded/metrics/brier_score.jl")
include("toplevel/always-loaded/metrics/coefficientofdetermination.jl")
include("toplevel/always-loaded/metrics/cohenkappa.jl")
include("toplevel/always-loaded/metrics/getbinarythresholds.jl")
include("toplevel/always-loaded/metrics/mean_square_error.jl")
include("toplevel/always-loaded/metrics/prcurve.jl")
include("toplevel/always-loaded/metrics/risk_score_cutoff_values.jl")
include("toplevel/always-loaded/metrics/roccurve.jl")
include("toplevel/always-loaded/metrics/rocnumsmetrics.jl")
include("toplevel/always-loaded/metrics/singlelabelbinaryclassificationmetrics.jl")
include("toplevel/always-loaded/metrics/singlelabelregressionmetrics.jl")

include("toplevel/always-loaded/modelselection/crossvalidation.jl")
include("toplevel/always-loaded/modelselection/split_data.jl")

include("toplevel/always-loaded/neuralnetwork/flux.jl")
include("toplevel/always-loaded/neuralnetwork/knet.jl")
include("toplevel/always-loaded/neuralnetwork/merlin.jl")

include("toplevel/always-loaded/online/onlinestats.jl")

include("toplevel/always-loaded/ontologies/ccs.jl")

include("toplevel/always-loaded/pipeline/simplelinearpipeline.jl")

include("toplevel/always-loaded/plotting/catch_plotting_errors.jl")
include("toplevel/always-loaded/plotting/defaultapplication.jl")
include("toplevel/always-loaded/plotting/pgfplots.jl")
include("toplevel/always-loaded/plotting/pgfplotsx.jl")
include("toplevel/always-loaded/plotting/plotlearningcurve.jl")
include("toplevel/always-loaded/plotting/plotprcurve.jl")
include("toplevel/always-loaded/plotting/plotroccurve.jl")
include("toplevel/always-loaded/plotting/plotsinglelabelregressiontruevspredicted.jl")
include("toplevel/always-loaded/plotting/plotsinglelabelbinaryclassifierhistograms.jl")
include("toplevel/always-loaded/plotting/probability_calibration_plots.jl")
include("toplevel/always-loaded/plotting/unicodeplots.jl")

include("toplevel/always-loaded/postprocessing/packagemultilabelpred.jl")
include("toplevel/always-loaded/postprocessing/packagesinglelabelpred.jl")
include("toplevel/always-loaded/postprocessing/packagesinglelabelproba.jl")
include("toplevel/always-loaded/postprocessing/predictoutput.jl")
include("toplevel/always-loaded/postprocessing/predictprobaoutput.jl")

include("toplevel/always-loaded/preprocessing/dataframecontrasts.jl")
include("toplevel/always-loaded/preprocessing/dataframetodecisiontree.jl")
include("toplevel/always-loaded/preprocessing/dataframetoglm.jl")
include("toplevel/always-loaded/preprocessing/dataframetoknet.jl")
include("toplevel/always-loaded/preprocessing/dataframetosvm.jl")

include("toplevel/always-loaded/svm/libsvm.jl")

include("toplevel/always-loaded/time_series/timeseries.jl")

include("toplevel/always-loaded/tree/decisiontree.jl")

include("toplevel/always-loaded/utils/constant_columns.jl")
include("toplevel/always-loaded/utils/dataframe_column_types.jl")
include("toplevel/always-loaded/utils/filename_extension.jl")
include("toplevel/always-loaded/utils/find.jl")
include("toplevel/always-loaded/utils/fix_type.jl")
include("toplevel/always-loaded/utils/formulas.jl")
include("toplevel/always-loaded/utils/inverse-dictionary.jl")
include("toplevel/always-loaded/utils/is_debug.jl")
include("toplevel/always-loaded/utils/labelstringintmaps.jl")
include("toplevel/always-loaded/utils/linearly_dependent_columns.jl")
include("toplevel/always-loaded/utils/make_directory.jl")
include("toplevel/always-loaded/utils/maketemp.jl")
include("toplevel/always-loaded/utils/missings.jl")
include("toplevel/always-loaded/utils/nothings.jl")
include("toplevel/always-loaded/utils/openbrowserwindow.jl")
include("toplevel/always-loaded/utils/openplotsduringtestsenv.jl")
include("toplevel/always-loaded/utils/predictionsassoctodataframe.jl")
include("toplevel/always-loaded/utils/probabilitiestopredictions.jl")
include("toplevel/always-loaded/utils/runtestsenv.jl")
include("toplevel/always-loaded/utils/shufflerows.jl")
include("toplevel/always-loaded/utils/simplemovingaverage.jl")
include("toplevel/always-loaded/utils/tikzpictures.jl")
include("toplevel/always-loaded/utils/transform_columns.jl")
include("toplevel/always-loaded/utils/trapz.jl")
include("toplevel/always-loaded/utils/traviscienv.jl")
include("toplevel/always-loaded/utils/tuplify.jl")

include("submodules/Cleaning/Cleaning.jl")
include("submodules/Compilation/Compilation.jl")
include("submodules/GPU/GPU.jl")
include("submodules/Server/Server.jl")

end # end module PredictMD
