##### Beginning of file

import Documenter
import Literate

function preprocess_example(content::AbstractString)
    content = replace(
        content,
        "PREDICTMD_CURRENT_VERSION" => string(
            version()
            )
        )
    content = replace(
        content,
        "PREDICTMD_NEXT_MINOR_VERSION" => string(
            next_minor_version(
                version();
                add_trailing_minus = true,
                )
            )
        )
    return content
end

function generate_examples(
        output_directory::AbstractString;
        execute_notebooks = false,
        markdown = false,
        notebooks = false,
        scripts = false,
        remove_existing_output_directory = false,
        )
    ENV["PREDICTMD_IS_MAKE_EXAMPLES"] = "true"
    if !markdown && !notebooks && !scripts
        error(
            string(
                "At least one of markdown, notebooks, scripts must be true",
                )
            )
    end
    if ispath(output_directory) && !remove_existing_output_directory
        error(
            string(
                "The output directory already exists. ",
                "Delete the output directory and then ",
                "re-run generate_examples."
                )
            )
    end
    info(string("Generating examples...",))
    temp_examples_dir = joinpath(
        mktempdir(),
        "generate_examples",
        "PredictMDTemp",
        "docs",
        "src",
        "examples",
        )
    mkpath(temp_examples_dir)

    examples_input_parent_directory =
        PredictMD.predictmd_package_directory("examples")

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
    sort!(boston_housing_input_file_list)
    for input_file in boston_housing_input_file_list
        input_file_full_path = joinpath(
            boston_housing_input_directory,
            input_file,
            )
        if markdown
            Literate.markdown(
                input_file_full_path,
                boston_housing_output_directory;
                documenter = true,
                preprocess = preprocess_example,
                )
        end
        if notebooks
            Literate.notebook(
                input_file_full_path,
                boston_housing_output_directory;
                documenter = true,
                execute = execute_notebooks,
                preprocess = preprocess_example,
                )
        end
        if scripts
            Literate.script(
                input_file_full_path,
                boston_housing_output_directory;
                documenter = true,
                keep_comments = true,
                preprocess = preprocess_example,
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
        readdir(breast_cancer_biopsy_input_directory)
    breast_cancer_biopsy_input_file_list =
        breast_cancer_biopsy_input_file_list[
            [endswith(x, ".jl") for x in
                breast_cancer_biopsy_input_file_list]
            ]
    sort!(breast_cancer_biopsy_input_file_list)
    for input_file in breast_cancer_biopsy_input_file_list
        input_file_full_path = joinpath(
            breast_cancer_biopsy_input_directory,
            input_file,
            )
        if markdown
            Literate.markdown(
                input_file_full_path,
                breast_cancer_biopsy_output_directory;
                documenter = true,
                preprocess = preprocess_example,
                )
        end
        if notebooks
            Literate.notebook(
                input_file_full_path,
                breast_cancer_biopsy_output_directory;
                documenter = true,
                execute = execute_notebooks,
                preprocess = preprocess_example,
                )
        end
        if scripts
            Literate.script(
                input_file_full_path,
                breast_cancer_biopsy_output_directory;
                documenter = true,
                keep_comments = true,
                preprocess = preprocess_example,
                )
        end
    end
    mkpath(dirname(output_directory))
    cp(
        temp_examples_dir,
        output_directory;
        remove_destination = true,
        )
    info(
        string(
            "Finished generating examples. ",
            "Files were written to: \"",
            output_directory,
            "\".",
            )
        )
    ENV["PREDICTMD_IS_MAKE_EXAMPLES"] = "false"
    return output_directory
end

##### End of file
