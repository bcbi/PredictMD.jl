srand(999)

using DataFrames
using DataTables
using StatsBase

num_rows = 500_000
dataframe, label_variables, feature_variables =
    AluthgeSinhaBase.generatefaketabulardata(num_rows)

countmap(dataframe[:mylabel1])

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
yscore_training= convert(Array, predict(m,DataTable(x_training)))
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
