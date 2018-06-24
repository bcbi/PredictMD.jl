# if is_windows()
#     execute_notebooks = false
# else
#     execute_notebooks = true
# end

import Documenter

function generate_docs(output_directory::AbstractString)
    if ispath(output_directory)
        error(
            string(
                "The output directory already exists. ",
                "Delete the output directory and then ",
                "re-run generate_docs."
                )
            )
    end
    temp_docs_dir = joinpath(
        tempname(),
        "generate_docs",
        "PredictMDTemp",
        "docs",
        )
    original_docs_directory = dir("docs")
    cp(
        original_docs_directory,
        temp_docs_dir;
        remove_destination = true,
        )
    temp_examples_dir = joinpath(
        temp_docs_dir,
        "src",
        "examples",
        )

    generate_examples(
        temp_examples_dir;
        execute_notebooks = true,
        markdown = true,
        notebooks = true,
        scripts = true,
        remove_existing_output_directory = true,
        )
end
