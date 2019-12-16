# This file was generated by PredictMD version 0.34.6
# For help, please visit https://predictmd.net

using PredictMDExtra
PredictMDExtra.import_all()

using PredictMD
PredictMD.import_all()



### Begin project-specific settings

DIRECTORY_CONTAINING_THIS_FILE = @__DIR__
PROJECT_DIRECTORY = dirname(
    joinpath(splitpath(DIRECTORY_CONTAINING_THIS_FILE)...)
    )
PROJECT_OUTPUT_DIRECTORY = joinpath(
    PROJECT_DIRECTORY,
    "output",
    )
mkpath(PROJECT_OUTPUT_DIRECTORY)
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "data"))
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "models"))
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "plots"))



### End project-specific settings

### Begin random forest regression code

Random.seed!(999)

trainingandtuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "trainingandtuning_features_df.csv",
    )
trainingandtuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "trainingandtuning_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "training_labels_df.csv",
    )
tuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "tuning_features_df.csv",
    )
tuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "tuning_labels_df.csv",
    )
trainingandtuning_features_df = DataFrames.DataFrame(
    FileIO.load(
        trainingandtuning_features_df_filename;
        type_detect_rows = 100,
        )
    )
trainingandtuning_labels_df = DataFrames.DataFrame(
    FileIO.load(
        trainingandtuning_labels_df_filename;
        type_detect_rows = 100,
        )
    )
testing_features_df = DataFrames.DataFrame(
    FileIO.load(
        testing_features_df_filename;
        type_detect_rows = 100,
        )
    )
testing_labels_df = DataFrames.DataFrame(
    FileIO.load(
        testing_labels_df_filename;
        type_detect_rows = 100,
        )
    )
training_features_df = DataFrames.DataFrame(
    FileIO.load(
        training_features_df_filename;
        type_detect_rows = 100,
        )
    )
training_labels_df = DataFrames.DataFrame(
    FileIO.load(
        training_labels_df_filename;
        type_detect_rows = 100,
        )
    )
tuning_features_df = DataFrames.DataFrame(
    FileIO.load(
        tuning_features_df_filename;
        type_detect_rows = 100,
        )
    )
tuning_labels_df = DataFrames.DataFrame(
    FileIO.load(
        tuning_labels_df_filename;
        type_detect_rows = 100,
        )
    )

categorical_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "categorical_feature_names.jld2",
    )
continuous_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "continuous_feature_names.jld2",
    )
categorical_feature_names = FileIO.load(
    categorical_feature_names_filename,
    "categorical_feature_names",
    )
continuous_feature_names = FileIO.load(
    continuous_feature_names_filename,
    "continuous_feature_names",
    )
feature_names = vcat(categorical_feature_names, continuous_feature_names)

single_label_name = :MedV

continuous_label_names = Symbol[single_label_name]
categorical_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

feature_contrasts = PredictMD.generate_feature_contrasts(
    training_features_df,
    feature_names,
    )

random_forest_regression =
    PredictMD.single_labeldataframerandomforestregression(
        feature_names,
        single_label_name;
        nsubfeatures = 2,
        ntrees = 20,
        package = :DecisionTree,
        name = "Random forest",
        feature_contrasts = feature_contrasts,
        )

PredictMD.fit!(random_forest_regression,
               training_features_df,
               training_labels_df)

random_forest_regression_plot_training =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        random_forest_regression,
        training_features_df,
        training_labels_df,
        single_label_name,
        );



display(random_forest_regression_plot_training)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "random_forest_regression_plot_training.pdf",
        ),
    random_forest_regression_plot_training,
    )

random_forest_regression_plot_testing =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        random_forest_regression,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        );



display(random_forest_regression_plot_testing)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "random_forest_regression_plot_testing.pdf",
        ),
    random_forest_regression_plot_testing,
    )

show(
    PredictMD.singlelabelregressionmetrics(
        random_forest_regression,
        training_features_df,
        training_labels_df,
        single_label_name,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

show(
    PredictMD.singlelabelregressionmetrics(
        random_forest_regression,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

random_forest_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "random_forest_regression.jld2",
    )

PredictMD.save_model(
    random_forest_regression_filename,
    random_forest_regression
    )



### End random forest regression code



# This file was generated by PredictMD version 0.34.6
# For help, please visit https://predictmd.net

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

