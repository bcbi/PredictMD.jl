import Documenter
import Literate

function generate_examples(
        output_directory::AbstractString;
        execute_notebooks = false,
        markdown = false,
        notebooks = true,
        scripts = true,
        remove_existing_output_directory = false,
        )
    ENV["PREDICTMD_IS_MAKE_EXAMPLES"] = "true"
    if ispath(output_directory) && !remove_existing_output_directory
        error(
            string(
                "The output directory already exists. ",
                "Delete the output directory and then ",
                "re-run generate_examples."
                )
            )
    end
    info("Generating examples...")
    temp_examples_dir = joinpath(
        tempname(),
        "generate_examples",
        "PredictMDTemp",
        "docs",
        "src",
        "examples",
        )
    mkpath(temp_examples_dir)

    examples_input_parent_directory = PredictMD.dir("examples")

    cpu_examples_input_parent_directory = joinpath(
        examples_input_parent_directory,
        "cpu",
        )
    cpu_examples_output_parent_directory = joinpath(
        temp_examples_dir,
        "cpu",
        )
    mkpath(cpu_examples_output_parent_directory)

    boston_housing_input_directory = joinpath(
        cpu_examples_input_parent_directory,
        "boston_housing",
        )
    boston_housing_output_directory = joinpath(
        cpu_examples_output_parent_directory,
        "boston_housing",
        )
    mkpath(boston_housing_output_directory)
    boston_housing_input_file_list =
        readdir(boston_housing_input_directory)
    boston_housing_input_file_list =
        boston_housing_input_file_list[
            [endswith(x, ".jl") for x in
                boston_housing_input_file_list]
            ]
    for input_file in boston_housing_input_file_list
        if markdown
            Literate.markdown(
                joinpath(
                    boston_housing_input_directory,
                    input_file,
                    ),
                boston_housing_output_directory;
                documenter = true,
                )
        end
        if notebooks
            Literate.notebook(
                joinpath(
                    boston_housing_input_directory,
                    input_file,
                    ),
                boston_housing_output_directory;
                documenter = true,
                execute = execute_notebooks,
                )
        end
        if scripts
            Literate.script(
                joinpath(
                    boston_housing_input_directory,
                    input_file,
                    ),
                boston_housing_output_directory;
                documenter = true,
                keep_comments = true,
                )
        end
    end

    breast_cancer_biopsy_input_directory = joinpath(
        cpu_examples_input_parent_directory,
        "breast_cancer_biopsy",
        )
    breast_cancer_biopsy_output_directory = joinpath(
        cpu_examples_output_parent_directory,
        "breast_cancer_biopsy",
        )
    mkpath(breast_cancer_biopsy_output_directory)
    breast_cancer_biopsy_input_file_list =
        readdir(boston_housing_input_directory)
    breast_cancer_biopsy_input_file_list =
        breast_cancer_biopsy_input_file_list[
            [endswith(x, ".jl") for x in
                breast_cancer_biopsy_input_file_list]
            ]
    for input_file in breast_cancer_biopsy_input_file_list
        if markdown
            Literate.markdown(
                joinpath(
                    breast_cancer_biopsy_input_directory,
                    input_file,
                    ),
                breast_cancer_biopsy_output_directory;
                documenter = true,
                )
        end
        if notebooks
            Literate.notebook(
                joinpath(
                    breast_cancer_biopsy_input_directory,
                    input_file,
                    ),
                breast_cancer_biopsy_output_directory;
                documenter = true,
                execute = execute_notebooks,
                )
        end
        if scripts
            Literate.script(
                joinpath(
                    breast_cancer_biopsy_input_directory,
                    input_file,
                    ),
                breast_cancer_biopsy_output_directory;
                documenter = true,
                keep_comments = true,
                )
        end
    end

    cp(
        temp_examples_dir,
        output_directory;
        remove_destination = true,
        )
    info("Finished generating examples.")
    ENV["PREDICTMD_IS_MAKE_EXAMPLES"] = "false"
end
