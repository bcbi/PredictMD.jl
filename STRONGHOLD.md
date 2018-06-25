# PredictMD on Stronghold

This document provides instructions for using PredictMD inside the [Stronghold](https://it.brown.edu/services/type/stronghold-data-compliance-research-environment) research environment for data compliance.

### Table of Contents
- [First-time setup](#first-time-setup)
- [Usage](#usage)

## First-time setup

Open the file `$HOME/.juliarc.jl` (creating it if it does not exist) and make sure that it contains the following line:
```julia
Base.LOAD_CACHE_PATH[1] = joinpath(ENV["HOME"], ".julia_cache")
```

## Usage

In Stronghold, open a new Terminal window and run the following command:
```bash
module load conda/bcbi_v0.0.1
```

Now Julia and PredictMD are available in your bash session.
