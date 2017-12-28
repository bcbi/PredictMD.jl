# AluthgeSinhaBase.jl

## Build Status

<table>
    <thead>
        <tr>
            <th>Branch</th>
            <th>Build Status</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="center">master</td>
            <td align="center"><a href="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl/branches"><img alt="Build Status (master)" title="Build Status (master)" src="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl.svg?token=dMqeEKHqcnWSXz982pdf&branch=master"></a></td>
        </tr>
        <tr>
            <td align="center">develop</td>
            <td align="center"><a href="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl/branches"><img alt="Build Status (develop)" title="Build Status (develop)" src="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl.svg?token=dMqeEKHqcnWSXz982pdf&branch=develop"></a></td>
        </tr>
        <tr>
            <td align="center" colspan="2"><a href="https://travis-ci.com/dilumaluthge/AluthgeSinhaBase.jl/branches">View build status for all branches</a></td>
        </tr>
    <tbody>
</table>

## Installation

**Step 1: Update your package directory:**
```julia
Pkg.update()
```

**Step 2: Install unregistered dependencies:**
```julia
Pkg.clone("https://github.com/bcbi/AUC.jl.git")
Pkg.clone("https://github.com/bcbi/ClassImbalance.jl.git")
Pkg.clone("https://github.com/johnmyleswhite/RDatasets.jl")
```

**Step 3: Install AluthgeSinhaBase:**
```julia
Pkg.clone("git@github.com:dilumaluthge/AluthgeSinhaBase.jl.git")
```

**Step 4: Checkout the master branch of AluthgeSinhaBase, which gives you the latest stable version:**
```julia
Pkg.checkout("AluthgeSinhaBase", "master")
```

**Step 5: Run the test suite:**
```julia
Pkg.test("AluthgeSinhaBase")
```
