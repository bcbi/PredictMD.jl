import Pkg; 

Pkg.Registry.add(Pkg.RegistrySpec(name="PredictMDRegistry",url="https://github.com/bcbi/PredictMDRegistry.git",uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9",)); 
Pkg.Registry.update(Pkg.RegistrySpec(name="PredictMDRegistry",uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9")); 

try
    Pkg.Registry.add("General"); 
catch e
    @info("ignoring exception: ", e,)
end
try
    Pkg.Registry.update("General"); 
catch e
    @info("ignoring exception: ", e,)
end
