## Instructions

Select the test group to run by setting the `PREDICTMD_TEST_GROUP` environment variable before running the test suite.

For example, to run the `all` test group, you would run the following lines in Julia:
```julia
ENV["PREDICTMD_TEST_GROUP"] = "all"
import Pkg
Pkg.test("PredictMD")
Pkg.test("PredictMDExtra")
Pkg.test("PredictMDFull")
```

## Available test groups

| group | default | all | test-plots | import-only | travis-1 | travis-2 | travis-3 | travis-4 | travis-5 | travis-6 | travis-7 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Import package | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| Unit tests | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | :white_check_mark: | :x: | :x: | :x: | :x: | :x: | :x: |
| Integration tests (1/7) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | :white_check_mark: | :x: | :x: | :x: | :x: | :x: | :x: |
| Integration tests (2/7) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | :x: | :white_check_mark: | :x: | :x: | :x: | :x: | :x: |
| Integration tests (3/7) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | :x: | :x: | :white_check_mark: | :x: | :x: | :x: | :x: |
| Integration tests (4/7) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | :x: | :x: | :x: | :white_check_mark: | :x: | :x: | :x: |
| Integration tests (5/7) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | :x: | :x: | :x: | :x: | :white_check_mark: | :x: | :x: |
| Integration tests (6/7) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | :x: | :x: | :x: | :x: | :x: | :white_check_mark: | :x: |
| Integration tests (7/7) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | :x: | :x: | :x: | :x: | :x: | :x: | :white_check_mark: |
| Test plots | :x: | :white_check_mark: | :white_check_mark: | :x: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
