import Pkg; 

Pkg.Registry.add(Pkg.RegistrySpec(name="PredictMDRegistry",url="https://github.com/bcbi/PredictMDRegistry.git",uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9",)); 

try
    Pkg.Registry.add("General"); 
catch e
    @info("ignoring exception: ", e,)
end

Pkg.Registry.update(Pkg.RegistrySpec(name="PredictMDRegistry",uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9")); 

try
    Pkg.Registry.update("General"); 
catch e
    @info("ignoring exception: ", e,)
end

Pkg.add(Pkg.PackageSpec(name="PredictMD",uuid="3e7d7328-36f8-4388-bd01-4613c92c7370")); 
Pkg.build("PredictMD"); 

Pkg.add(Pkg.PackageSpec(name="PredictMDExtra",uuid="d14d998a-9e6b-11e8-16d3-6f2879ea456d")); 
Pkg.build("PredictMDExtra"); 

Pkg.add(Pkg.PackageSpec(name="PredictMDFull",uuid="5c0c5c38-9dd5-11e8-3ab7-453bd9ce6c97")); 
Pkg.build("PredictMDFull"); 

Pkg.build("PredictMD"); 
Pkg.build("PredictMDExtra"); 
Pkg.build("PredictMDFull"); 

ENV["JULIA_DEBUG"] = "all"; 

import PredictMD; 
import PredictMDExtra; 
import PredictMDFull; 

println("PredictMD was installed successfully."); 
println("You are now ready to use PredictMD."); 
println("For help, visit https://predictmd.net"); 
