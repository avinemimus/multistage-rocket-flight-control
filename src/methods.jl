include("models.jl")

function velocityDeltas(rocket::Rocket)
    deltas = []
    mass = rocket.mPayload
    for stage in rocket.stages
        mass += stage.mFull
    end

    for stage in rocket.stages
        append!(deltas, stage.c * log(mass / (mass - stage.mFuel)))
        mass -= stage.mFull
    end

    return deltas
end
