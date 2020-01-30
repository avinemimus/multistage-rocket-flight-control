include("models.jl")

function initialMass(rocket::Rocket)
    mass = rocket.mPayload
    for stage in rocket.stages
        mass += stage.mFull
    end
    return mass
end

function velocityDeltas(rocket::Rocket)
    deltas = []
    mass = initialMass(rocket)

    for stage in rocket.stages
        push!(deltas, stage.c * log(mass / (mass - stage.mFuel)))
        mass -= stage.mFull
    end

    return deltas
end

function rs(rocket::Rocket)
    r = []
    mass = initialMass(rocket)

    for stage in rocket.stages
        push!(r, mass / (mass - stage.mFuel))
        mass -= stage.mFull
    end
    return r
end

function λs(rocket::Rocket)
    λ = []
    mass = initialMass(rocket)

    for stage in rocket.stages
        push!(λ, (mass - stage.mFull) / (mass))
        mass -= stage.mFull
    end
    return λ
end

function εs(rocket::Rocket)
    ε = []
    mass = initialMass(rocket)

    for stage in rocket.stages
        push!(ε, (stage.mFull - stage.mFuel) / (mass))
        mass -= stage.mFull
    end
    return ε
end
