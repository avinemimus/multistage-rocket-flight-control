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

function idealVelocity(rocket::Rocket)
    return reduce(+, velocityDeltas(rocket))
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
"""
function linearMass(t::Float64, rocket::Rocket)
        m = initialMass(rocket)
        count = 0
        for stage in rocket.stages
                if stage.mFuel <= stage.mFlowRate * t
                        m -= stage.mFull
                        count += 1
                end
        end
        if count + 1 <= length(rocket.stages)
                m -= rocket.stages[count + 1].mFlowRate * t
        end
        return m
end

function hsBurnOut(rocket::Rocket)
        h = []
        mass = initialMass(rocket)
        for stage in rocket.stages
                m0 = mass
                mf = mass - stage.mFuel
                hbo = (stage.c / stage.mFlowRate) * (mf * log(mf / m0) + m0 - mf)
                push!(h, hbo)
                mass -= stage.mFull
        end
        return h
end

function hBurnOut(rocket::Rocket)
        return reduce(+, hsBurnOut(rocket))
end

function g(h::Float64)
    return g0 * (1 - 2 * h / R)
end
"""
