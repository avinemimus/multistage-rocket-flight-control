include("src/models.jl")
include("src/methods.jl")

mass0 = 10000
stages = [Stage(368100, 331300, 2.9),
          Stage(55900,  50300,  2.9)]
rocket = Rocket(mass0, stages)

# 1. Tsiolkovsky equation
deltas = velocityDeltas(rocket)
println("Number of stages: $(length(rocket.stages))\n")
for (number, stage) in enumerate(rocket.stages)
    println("Stage $(number)")
    println("mFull = $(stage.mFull), mFuel = $(stage.mFuel), c = $(stage.c)")
    println("deltaV = $(deltas[number])\n")
end

deltaVSum = reduce(+, velocityDeltas(rocket))
println("deltaVSum = $(deltaVSum)\n")

# 2. Weight distribution coefficients. Note : λ + ε = 1/r
(r, λ, ε)  = (rs(rocket), λs(rocket), εs(rocket))

println("Mass numbers: $(r)")
println("Payload coefficients: $(λ)")
println("Construction coefficients: $(ε)\n")

for i in 1:length(rocket.stages)
    println("$(λ[i] + ε[i]) = $(1 / r[i])")
end
