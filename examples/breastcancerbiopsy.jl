##############################################################################
##############################################################################
### INSTRUCTIONS FOR USING THIS FILE: ########################################
##############################################################################
##############################################################################
##
## If you are running this file for the first time and/or if you do not have
## any trained models saved to disk, take the following steps:
##     1. Uncomment lines 27 and 28
##     2. Comment out lines 30 and 31
##     3. Set the variables on lines 33 through 38 to the filenames where you
##        would like to save your models after training them.
##     4. Run the entire file. This will train the models, compare their
##        performance, print metrics to the console, generate plots, and save
##        the trained models to disk.
##
## If you already have trained models saved, and you would like to load those
## models from disk, take the following steps:
##     1. Comment out lines 27 and 28
##     2. Uncomment lines 30 and 31
##     3. Make sure the variables on lines 33 through 38 are set to the
##        filenames where your trained models are currently saved.
##     4. Run the entire file. This will load the trained models from disk,
##        compare their performance, print metrics to the console, and generate
##        plots.

# ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
# ENV["SAVETRAINEDMODELSTOFILE"] = "true"

# ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
# ENV["SAVETRAINEDMODELSTOFILE"] = "false"

logisticclassifier_filename = "/Users/dilum/Desktop/logisticclassifier.jld2"
probitclassifier_filename = "/Users/dilum/Desktop/probitclassifier.jld2"
rfclassifier_filename = "/Users/dilum/Desktop/rfclassifier.jld2"
csvc_svmclassifier_filename = "/Users/dilum/Desktop/csvc_svmclassifier.jld2"
nusvc_svmclassifier_filename = "/Users/dilum/Desktop/nusvc_svmclassifier.jld2"
knetmlp_filename = "/Users/dilum/Desktop/knetmlpclassifier.jld2"
