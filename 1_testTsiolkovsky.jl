include("src/models.jl")
include("src/methods.jl")

mass0 = 10000
stages = [Stage(368100, 331300, 2.9),
          Stage(55900,  50300,  2.9)]
rocket = Rocket(mass0, stages)

deltas = velocityDeltas(rocket)

println("Number of stages: $(length(rocket.stages))\n")
for (number, stage) in enumerate(rocket.stages)
    println("Stage $(number)")
    println("mFull = $(stage.mFull), mFuel = $(stage.mFuel), c = $(stage.c)")
    println("deltaV = $(deltas[number])\n")
end

deltaVSum = reduce(+, velocityDeltas(rocket))
println("deltaVSum = $(deltaVSum)\n")
