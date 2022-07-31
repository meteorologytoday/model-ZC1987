
mutable struct Model

    env   :: Env
    state :: State 
    core  :: Core
    
    function Model(
        env :: Env,
    )
        
        state = State(env)
        core  = Core(env)

        
        return new(
            env,
            state,
            core,
        )

    end

end

