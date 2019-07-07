# [Docker image](@id docker_image)

You can use the PredictMD Docker image for easy installation of PredictMD and all of its dependencies. Download and start the container by running the following line:
```bash
docker run --name predictmd -it dilumaluthge/predictmd /bin/bash
```

Once you are inside the container, you can start Julia by running the following line:
```bash
julia
```

In Julia, run the following line to load PredictMD:
```julia
import PredictMDFull
```

You can run the test suite by running the following four lines in Julia:
```julia
import Pkg
Pkg.test("PredictMD")
Pkg.test("PredictMDExtra")
Pkg.test("PredictMDFull")
```

After you have exited the container, you can return to it by running the following line:
```bash
docker start -ai predictmd
```

To delete your container, run the following line:
```bash
docker container rm -f predictmd
```

To also delete the downloaded image, run the following line:
```bash
docker image rm -f dilumaluthge/predictmd
