include("models.jl")

using Roots

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

function λsOptimized(v::Float64, c::Vector{Float64}, ε::Vector{Float64}, n::Int64)
    averC = reduce(+, c) / n
    R = exp(v / averC)
    ∏ = R * reduce(*, [ε[i] ^ (c[i] / averC) for i in 1:n])
    f(x) = prod([(1 - (c[n] / c[i]) * x) ^ (c[i] / averC) for i in 1:n]) - ∏

    l = find_zero(f, 0.0)
    λn = (ε[n] * l) / (1 - l)

    λ = [ε[i] / (1 - c[n] * l / c[i]) - ε[i] for i in 1:n-1]
    push!(λ, λn)

    return λ
end

function rsOptimized(λs::Vector{Float64}, εs::Vector{Float64}, n::Int64)
    return [1 / (λs[i] + ε[i]) for i in 1:n]
end

function coefG(λs::Vector{Float64})
    return 1 / prod(λs)
end
