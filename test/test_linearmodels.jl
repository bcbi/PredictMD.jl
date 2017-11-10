srand(999)

using DataFrames
using DataTables
using StatsBase

num_rows = 50_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata1(num_rows)

StatsBase.countmap(dataframe[:mylabel1])

tabular_dataset = HoldoutTabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=0.5,
    validation=0.2,
    testing=0.3,
    )

logistic_binary_classifier = SingleLabelBinaryLogisticClassifier(
    tabular_dataset,
    :mylabel1,
    )

@test(
    typeof(logistic_binary_classifier) <:
        AbstractSingleLabelBinaryClassifier
    )

modelperformance_logistic_binary_classifier = ModelPerformance(
    logistic_binary_classifier,
    )

@test(
    typeof(modelperformance_logistic_binary_classifier) <:
        AbstractModelPerformance
    )

m = logistic_binary_classifier.blobs[:model]

x_training, r_training= getdata(
    tabular_dataset;
    training = true,
    features = true,
    )
ytrue_training= convert(Array, getdata(
    tabular_dataset;
    recordidlist = r_training,
    single_label = true,
    label_variable = :mylabel1,
    label_type = :integer,
    ))
yscore_training = convert(Array, predict(m,DataTable(x_training)))
mean(Int.(yscore_training.>0.5).==ytrue_training)

x_validation, r_validation = getdata(
    tabular_dataset;
    validation = true,
    features = true,
    )
ytrue_validation = convert(Array, getdata(
    tabular_dataset;
    recordidlist = r_validation,
    single_label = true,
    label_variable = :mylabel1,
    label_type = :integer,
    ))
yscore_validation = convert(Array, predict(m,DataTable(x_validation)))
mean(Int.(yscore_validation.>0.5).==ytrue_validation)

x_testing, r_testing = getdata(
    tabular_dataset;
    testing = true,
    features = true,
    )
ytrue_testing = convert(Array, getdata(
    tabular_dataset;
    recordidlist = r_testing,
    single_label = true,
    label_variable = :mylabel1,
    label_type = :integer,
    ))
yscore_testing = convert(Array, predict(m,DataTable(x_testing)))
mean(Int.(yscore_testing.>0.5).==ytrue_testing)

##############################################################################

num_rows = 50_000
dataframe, label_variables, feature_variables =
        AluthgeSinhaBase.generatefaketabulardata2(num_rows)

tabular_dataset = AluthgeSinhaBase.HoldoutTabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=0.5,
    validation=0.2,
    testing=0.3,
    )

num_iterations = 10
training_accuracies = -99*ones(Cfloat, num_iterations)
validation_accuracies = -99*ones(Cfloat, num_iterations)
testing_accuracies = -99*ones(Cfloat, num_iterations)
for i = 1:num_iterations
    logistic_binary_classifier = AluthgeSinhaBase.SingleLabelBinaryLogisticClassifier(
        tabular_dataset,
        :y,
        )
    modelperformance_logistic_binary_classifier = AluthgeSinhaBase.ModelPerformance(
        logistic_binary_classifier,
        )
    mp = modelperformance_logistic_binary_classifier
    training_accuracies[i] = mp.blobs[:accuracy_training]
    validation_accuracies[i] = mp.blobs[:accuracy_validation]
    testing_accuracies[i] = mp.blobs[:accuracy_testing]
end





##############################################################################

num_rows = 50_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata3(num_rows)

tabular_dataset = AluthgeSinhaBase.HoldoutTabularDataset(
    dataframe,
    label_variables,
    feature_variables;
    training=0.7,
    testing=0.3,
    )

logistic_binary_classifier = AluthgeSinhaBase.SingleLabelBinaryLogisticClassifier(
    tabular_dataset,
    :deathoutcome,
    )

modelperformance_logistic_binary_classifier = AluthgeSinhaBase.ModelPerformance(
    logistic_binary_classifier,
    )
