## Instructions

Select the test group to run by setting the `PREDICTMD_TEST_GROUP` environment variable before running the test suite.

For example, to run the `all` test group, you would run the following lines in Julia:
```julia
ENV["PREDICTMD_TEST_GROUP"] = "all"
import Pkg
Pkg.test("PredictMD")
```

## Available test groups

| group | default | all | test-plots | import-only | travis-1 | travis-2 | travis-3 | travis-4 | travis-5 | travis-6 | travis-7 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Import package | YES | YES | YES | YES | YES | YES | YES | YES | YES | YES | YES |
| Unit tests | YES | YES | YES | NO | YES | NO | NO | NO | NO | NO | NO |
| Integration tests (1/7) | YES | YES | YES | NO | YES | NO | NO | NO | NO | NO | NO |
| Integration tests (2/7) | YES | YES | YES | NO | NO | YES | NO | NO | NO | NO | NO |
| Integration tests (3/7) | YES | YES | YES | NO | NO | NO | YES | NO | NO | NO | NO |
| Integration tests (4/7) | YES | YES | YES | NO | NO | NO | NO | YES | NO | NO | NO |
| Integration tests (5/7) | YES | YES | YES | NO | NO | NO | NO | NO | YES | NO | NO |
| Integration tests (6/7) | YES | YES | YES | NO | NO | NO | NO | NO | NO | YES | NO |
| Integration tests (7/7) | YES | YES | YES | NO | NO | NO | NO | NO | NO | NO | YES |
| Test plots | NO | YES | YES | NO | YES | YES | YES | YES | YES | YES | YES |
