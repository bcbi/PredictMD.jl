##### Beginning of file

import Documenter
import Literate

function fix_example_blocks(filename::AbstractString)::Nothing
    content = read(filename, String)
    rm(filename; force = true, recursive = true,)
    pattern = r"```@example \w*\n"
    replacement = "```julia\n"
    content = replace(content, pattern => replacement)
    write(filename, content)
    return nothing
end

"""
"""
function generate_docs(
        output_directory::AbstractString;
        execute_notebooks = true,
        markdown = true,
        notebooks = true,
        scripts = true,
        include_test_statements::Bool = false,
        )

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

    @info("Starting to generate docs...")

    temp_generatedocs_dir = joinpath(
        mktempdir(),
        "generate_docs",
        "PredictMDTemp",
        "docs",
        )
    original_docs_directory = package_directory("docs")
    mkpath(dirname(temp_generatedocs_dir))
    cp(
        original_docs_directory,
        temp_generatedocs_dir;
        force = true,
        )
    temp_examples_dir = joinpath(
        temp_generatedocs_dir,
        "src",
        "examples",
        )

    generate_examples(
        temp_examples_dir;
        execute_notebooks = execute_notebooks,
        markdown = markdown,
        notebooks = notebooks,
        scripts = scripts,
        include_test_statements = include_test_statements,
        )
    if Base.Sys.iswindows()
        @warn(
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
                PredictMD.Cleaning,
                PredictMD.Compilation,
                PredictMD.GPU,
                PredictMD.Server,
                ],
            pages = Any[
                "index.md",
                "requirements_for_plotting.md",
                "library/internals.md",
                ],
            root = temp_generatedocs_dir,
            sitename = "PredictMD documentation",
            )
        for (root, dirs, files) in walkdir(temp_generatedocs_dir)
            for file in files
                filename = joinpath(root, file)
                if filename_extension(filename) == ".md"
                    fix_example_blocks(filename)
                end
            end
        end
        cd(previous_working_directory)
    end
    mkpath(dirname(output_directory))
    cp(
        temp_generatedocs_dir,
        output_directory,
        )
    @info(
        string(
            "Finished generating docs. ",
            "Files were written to: \"",
            output_directory,
            "\".",
            )
        )
    ENV["PREDICTMD_IS_MAKE_DOCS"] = "false"
    return output_directory
end

##### End of file
