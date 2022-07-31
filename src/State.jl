mutable struct State

    # prefix underscore "_" means the 1D shaped.

    # X means tracer. _X is a special variable that contains
    # all the tracers.
    _X     :: AbstractArray{Float64, 1}
    
    # Suffix underscroe "_" means the last index is the
    # tracer type index.
    _X_      :: AbstractArray{Float64, 2}

    # View each X as a 3D array.
    X_       :: AbstractArray{Float64, 4}

    # "tgt" means target.
    _X_tgt :: AbstractArray{Float64, 1}
    _X_tgt_ :: AbstractArray{Float64, 2}
    X_tgt_  :: AbstractArray{Float64, 4}

    # T and S are reshpaed array referencing X (first two tracers)
    _T    :: AbstractArray{Float64, 1}
    _S    :: AbstractArray{Float64, 1}
    T     :: AbstractArray{Float64, 3}
    S     :: AbstractArray{Float64, 3}

    # T_tgt and S_tgt are reshaped array referencing X_tgt
    _T_tgt :: AbstractArray{Float64, 1}
    _S_tgt :: AbstractArray{Float64, 1}
    T_tgt  :: AbstractArray{Float64, 3}
    S_tgt  :: AbstractArray{Float64, 3}

    # Tracer constant source and sink term.
    _X_SS  :: AbstractArray{Float64, 1}
    _X_SS_ :: AbstractArray{Float64, 2}
    X_SS_  :: AbstractArray{Float64, 4}

    _T_SS :: AbstractArray{Float64, 1}
    _S_SS :: AbstractArray{Float64, 1}
    T_SS  :: AbstractArray{Float64, 3}
    S_SS  :: AbstractArray{Float64, 3}

    # Buoyancy
    _b     :: AbstractArray{Float64, 1}
    b     :: AbstractArray{Float64, 3}

    # u, v, and w are reshaped array referencing _vel
    _vel   :: AbstractArray{Float64, 1}
    u     :: AbstractArray{Float64, 3}
    v     :: AbstractArray{Float64, 3}
    w     :: AbstractArray{Float64, 3}

    Ψb :: AbstractArray{Float64, 2}
    Ψb_star :: AbstractArray{Float64, 2}
  
    # Diagnostic variables
    diag :: Dict

    function State(
        env :: Env,
    )
        NX = env.NX
        Ny_bsn = env.Ny_bsn
        Nz = env.Nz

        V_pts = (Ny_bsn+1) * Nz * 2
        W_pts = (Nz+1) * Ny_bsn * 2
        T_pts = Ny_bsn * Nz * 2
        U_pts = Ny_bsn * Nz * 3

        # buoyancy
        _b = zeros(Float64, T_pts)
        b = reshape(_b, Nz, Ny_bsn, 2)
        bw = view(b, :, :, 1)
        be = view(b, :, :, 2)

        # velocities
        _vel = zeros(Float64, V_pts + W_pts + U_pts)

        idx = 0
        u = reshape(view(_vel, (idx+1):(idx+=U_pts)), Nz, Ny_bsn,   3)
        v = reshape(view(_vel, (idx+1):(idx+=V_pts)), Nz, Ny_bsn+1, 2)
        w = reshape(view(_vel, (idx+1):(idx+=W_pts)), Nz+1, Ny_bsn, 2)

        # state variables: T and S
        _X  = zeros(Float64, NX*T_pts)
        _X_ = reshape(_X, T_pts, NX)
        X_  = reshape(_X, Nz, Ny_bsn, 2, NX)

        _T = view(_X_, :, 1)
        _S = view(_X_, :, 2)
        T  = view(X_, :, :, :, 1)
        S  = view(X_, :, :, :, 2)

        _X_tgt  = zeros(Float64, NX*T_pts)
        _X_tgt_ = reshape(_X_tgt, T_pts, NX)
        X_tgt_  = reshape(_X_tgt, Nz, Ny_bsn, 2, NX)

        _T_tgt = view(_X_tgt_, :, 1)
        _S_tgt = view(_X_tgt_, :, 2)
        T_tgt  = view(X_tgt_, :, :, :, 1)
        S_tgt  = view(X_tgt_, :, :, :, 2)

        _X_SS = zeros(Float64, NX*T_pts)
        _X_SS_ = reshape(_X_SS, T_pts, NX)
        X_SS_  = reshape(_X_SS, Nz, Ny_bsn, 2, NX)

        _T_SS = view(_X_SS_, :, 1)
        _S_SS = view(_X_SS_, :, 2)
        T_SS  = view(X_SS_, :, :, :, 1)
        S_SS  = view(X_SS_, :, :, :, 2)


        #=
        ui = view(u, :, :, 2)

        vw = view(v, :, :, 1)
        ve = view(v, :, :, 2)

        ww = view(w, :, :, 1)
        we = view(w, :, :, 2)
        =#

        Ψb = zeros(Float64, Nz+1, Ny_bsn+1)
        Ψb_star = zeros(Float64, Nz+1, Ny_bsn+1)
       
        _tmp = zeros(Float64, NX)
        diag = Dict(
            :∫X          => copy(_tmp),
            :∫ADV        => copy(_tmp),
            :∫HDIF       => copy(_tmp),
            :∫VDIF       => copy(_tmp),
            :∫SS         => copy(_tmp),
            :∫ERR        => copy(_tmp),
            :ρc∫vT       => zeros(Float64, Ny_bsn+1),
            :ρ∫vS        => zeros(Float64, Ny_bsn+1),
        ) 
        
        
        return new(

            _X,
            _X_,
            X_,

                        
            _X_tgt,
            _X_tgt_,
            X_tgt_,

            _T,
            _S,
            T,
            S,

            _T_tgt,
            _S_tgt,
            T_tgt,
            S_tgt,

            _X_SS,
            _X_SS_,
            X_SS_,

            _T_SS,
            _S_SS,
            T_SS,
            S_SS, 


            _b,
            b,

            _vel,
            u,
            v,
            w,

            Ψb,
            Ψb_star,
           
            diag,       

        )
    end

end


