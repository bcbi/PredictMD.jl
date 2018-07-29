<!-- Beginning of file -->

# Generating example files locally

You can generate the example files using the `generate_examples`
function. Instructions for using the `generate_examples` are given below.

In the following code snippets, `output_directory` is the directory where
you want to save the generated example files. `output_directory` should NOT
be an existing directory. If `output_directory` already exists, you should
delete it before running the `generate_examples` function.

## Generating scripts (.jl files)

To generate the examples as Julia scripts (.jl files), use the
following code.

```julia
PredictMD.generate_examples(output_directory; scripts = true)
```

## Generating IJulia/Jupyter notebooks (.ipynb files)

To generate the examples as IJulia/Jupyter notebooks (.ipynb files), use the
following code. `output_directory` is the directory where you want to save
the generated example files. `output_directory` should NOT be an existing
directory. If `output_directory` already exists, you should delete it before
running the `generate_examples` function.

```julia
PredictMD.generate_examples(output_directory; notebooks = true)
```

<!-- End of file -->
