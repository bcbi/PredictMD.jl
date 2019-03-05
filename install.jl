import Pkg; 

Pkg.Registry.add(Pkg.RegistrySpec(url="https://github.com/bcbi/PredictMDRegistry.git")); 
Pkg.Registry.update(Pkg.RegistrySpec(uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9")); 

Pkg.add("PredictMD"); 
Pkg.build("PredictMD"); 

Pkg.add("PredictMDExtra"); 
Pkg.build("PredictMDExtra"); 

Pkg.add("PredictMDFull"); 
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
