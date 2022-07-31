
if :NewtonMethod ∉ names(Main)
    include("NewtonMethod.jl")
end

module ZAOM

    using SparseArrays
    using LinearAlgebra
    using Formatting
    using NCDatasets

    using ..NewtonMethod

    @inline function mul_autoflat!(
        a :: AbstractArray{Float64},
        b :: AbstractArray{Float64, 2},
        c :: AbstractArray{Float64},
    )
        mul!(view(a, :), b, view(c, :))
    end
  
    macro fast_extract(model)
        return esc(:( 
            co = $(model).core;
            st = $(model).state;
            ev = $(model).env;
        ))
    end

    include("constants.jl")
    include("ocean_state_function.jl")

    include("Grid.jl")
    include("TracerForcing.jl")

    include("MatrixOperators.jl")
    include("MatrixSpatialOperators.jl")
    include("EllipticSolver.jl")
    include("VerticalDiffusionSolver.jl")
    include("HorizontalDiffusionSolver.jl")
    include("Workspace.jl")

    include("Env.jl")
    include("State.jl")
    include("Core.jl")
    include("Model.jl")

    
    include("FileIO.jl")

    include("scheme_operators.jl")
    include("step_model_nwt.jl")
    include("step_model_rk2.jl")
    include("miscellaneous_functions.jl")
    include("salt_forcing_functions.jl")
    include("print_info.jl")

    include("diagnose.jl")
end
