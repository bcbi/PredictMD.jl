import PredictMDAPI

# types

const AbstractFittable = PredictMDAPI.AbstractFittable
const AbstractEstimator = PredictMDAPI.AbstractEstimator
const AbstractPipeline = PredictMDAPI.AbstractPipeline
const AbstractTransformer = PredictMDAPI.AbstractTransformer

const AbstractFeatureContrasts = PredictMDAPI.AbstractFeatureContrasts
const AbstractNonExistentFeatureContrasts = PredictMDAPI.AbstractNonExistentFeatureContrasts

const AbstractNonExistentUnderlyingObject = PredictMDAPI.AbstractNonExistentUnderlyingObject

const AbstractBackend = PredictMDAPI.AbstractBackend

const AbstractPlot = PredictMDAPI.AbstractPlot

# traits

# const TargetStyle = PredictMDAPI.TargetStyle
# const UnknownTargetStyle = PredictMDAPI.UnknownTargetStyle
# const MixedTargetStyle = PredictMDAPI.MixedTargetStyle
# const Regression = PredictMDAPI.Regression
# const Classification{N} = PredictMDAPI.Classification{N}
# const BinaryClassification = PredictMDAPI.BinaryClassification

# functions

const fit! = PredictMDAPI.fit!
const get_history = PredictMDAPI.get_history
const get_underlying = PredictMDAPI.get_underlying
const parse_functions! = PredictMDAPI.parse_functions!
const predict = PredictMDAPI.predict
const predict_proba = PredictMDAPI.predict_proba
const set_feature_contrasts! = PredictMDAPI.set_feature_contrasts!
const set_max_epochs! = PredictMDAPI.set_max_epochs!
const transform = PredictMDAPI.transform

const accuracy = PredictMDAPI.accuracy
const auprc = PredictMDAPI.auprc
const aurocc = PredictMDAPI.aurocc
const binary_brier_score = PredictMDAPI.binary_brier_score
const cohen_kappa = PredictMDAPI.cohen_kappa
const f1score = PredictMDAPI.f1score
const false_negative_rate = PredictMDAPI.false_negative_rate
const false_positive_rate = PredictMDAPI.false_positive_rate
const fbetascore = PredictMDAPI.fbetascore
const mean_squared_error = PredictMDAPI.mean_squared_error
const negative_predictive_value = PredictMDAPI.negative_predictive_value
const positive_predictive_value = PredictMDAPI.positive_predictive_value
const prcurve = PredictMDAPI.prcurve
const precision = PredictMDAPI.precision
const r2score = PredictMDAPI.r2score
const recall = PredictMDAPI.recall
const roccurve = PredictMDAPI.roccurve
const root_mean_squared_error = PredictMDAPI.root_mean_squared_error
const sensitivity = PredictMDAPI.sensitivity
const specificity = PredictMDAPI.specificity
const true_negative_rate = PredictMDAPI.true_negative_rate
const true_positive_rate = PredictMDAPI.true_positive_rate

const plotlearningcurve = PredictMDAPI.plotlearningcurve
const plotprcurve = PredictMDAPI.plotprcurve
const plotroccurve = PredictMDAPI.plotroccurve

const load_model = PredictMDAPI.load_model
const save_model = PredictMDAPI.save_model
const save_plot = PredictMDAPI.save_plot
