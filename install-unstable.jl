import Pkg; 

try
    Pkg.Registry.add(Pkg.RegistrySpec(name="General",)); 
catch e
    @info("ignoring exception: ", e,)
end

try
    Pkg.Registry.update(Pkg.RegistrySpec(name="General",)); 
catch e
    @info("ignoring exception: ", e,)
end

Pkg.add(Pkg.PackageSpec(name="PredictMD",rev="develop",url="https://github.com/bcbi/PredictMD.jl",uuid="3e7d7328-36f8-4388-bd01-4613c92c7370",)); 
Pkg.build("PredictMD"); 

Pkg.add(Pkg.PackageSpec(name="PredictMDExtra",rev="develop",url="https://github.com/bcbi/PredictMDExtra.jl",uuid="d14d998a-9e6b-11e8-16d3-6f2879ea456d",)); 
Pkg.build("PredictMDExtra"); 

Pkg.add(Pkg.PackageSpec(name="PredictMDFull",rev="develop",url="https://github.com/bcbi/PredictMDFull.jl",uuid="5c0c5c38-9dd5-11e8-3ab7-453bd9ce6c97",)); 
Pkg.build("PredictMDFull"); 

ENV["JULIA_DEBUG"] = "all"; 

import PredictMD; 
import PredictMDExtra; 
import PredictMDFull; 

println("PredictMD (unstable develop branch) was installed successfully."); 
println("You are now ready to use PredictMD."); 
println("For help, visit https://predictmd.net"); 
