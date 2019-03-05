import Pkg; 

Pkg.add(Pkg.PackageSpec(url="https://github.com/bcbi/PredictMD.jl", rev="develop")); 
Pkg.build("PredictMD"); 

Pkg.add(Pkg.PackageSpec(url="https://github.com/bcbi/PredictMDExtra.jl", rev="develop")); 
Pkg.build("PredictMDExtra"); 

Pkg.add(Pkg.PackageSpec(url="https://github.com/bcbi/PredictMDFull.jl", rev="develop")); 
Pkg.build("PredictMDFull"); 

ENV["JULIA_DEBUG"] = "all"; 

import PredictMD; 
import PredictMDExtra; 
import PredictMDFull; 

println("PredictMD (unstable develop branch) was installed successfully."); 
println("You are now ready to use PredictMD."); 
println("For help, visit https://predictmd.net"); 
