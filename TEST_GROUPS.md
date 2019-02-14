## Instructions

Select the test group to run by setting the `PREDICTMD_TEST_GROUP` environment variable before running the test suite.

For example, to run the `all` test group, you would run the following lines in Julia:
```julia
ENV["PREDICTMD_TEST_GROUP"] = "all"
import Pkg
Pkg.test("PredictMD")
```

## Available test groups

| group| Unit tests | Integration tests | Plotting tests | 
| :--- | :---: | :---: | :---: |
| default| <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"> </a>| <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> | <a href="#available-test-groups"><img alt="Yes" title="No" src="https://via.placeholder.com/25x25/ff0000/ffffff.png?text=+"></a> |
| all | <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> | <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> | <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> |
| test-plots | <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> | <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"> </a>| <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> |
| travis-1 | <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> | <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> | <a href="#available-test-groups"><img alt="Yes" title="Yes" src="https://via.placeholder.com/25x25/00ff00/000000.png?text=+"></a> |
