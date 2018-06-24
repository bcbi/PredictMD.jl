import Documenter
import Literate

function generate_docs(output_directory::AbstractString)
    ENV["PREDICTMD_IS_MAKE_DOCS"] = "true"
    if ispath(output_directory)
        error(
            string(
                "The output directory already exists. Delete ",
                "the output directory and then re-run ",
                "generate_docs."
                )
            )
    end
    info("Generating docs...")
    temp_generatedocs_dir = joinpath(
        tempname(),
        "generate_docs",
        "PredictMDTemp",
        "docs",
        )
    original_docs_directory = dir("docs")
    mkpath(dirname(temp_generatedocs_dir))
    cp(
        original_docs_directory,
        temp_generatedocs_dir;
        remove_destination = true,
        )
    temp_examples_dir = joinpath(
        temp_generatedocs_dir,
        "src",
        "examples",
        )
    if is_windows()
        execute_notebooks = false
    else
        execute_notebooks = true
    end
    generate_examples(
        temp_examples_dir;
        execute_notebooks = execute_notebooks,
        markdown = true,
        notebooks = true,
        scripts = true,
        remove_existing_output_directory =
            true,
        )
    if is_windows()
        warn(
            string(
                "documentation generation is not supported on Windows, ",
                "so Documenter.makedocs will not be run",
                )
            )
    else
        previous_working_directory = pwd()
        cd(temp_generatedocs_dir)
        Documenter.makedocs(
            modules = [
                PredictMD,
                PredictMD.Clean,
                PredictMD.GPU,
                ],
            sitename = "PredictMD documentation",
            pages = Any[
                "index.md",
                "requirements_for_plotting.md",
                "library/internals.md",
                ],
            )
        cd(previous_working_directory)
    end
    mkpath(dirname(output_directory))
    cp(
        temp_generatedocs_dir,
        output_directory,
        )
    info("Finished generating docs.")
    ENV["PREDICTMD_IS_MAKE_DOCS"] = "false"
    return output_directory
end
