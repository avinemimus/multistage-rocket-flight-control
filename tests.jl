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

# 3. Engineering with weight optimization
v = 9500.0
cOpt = [[3000.0, 4000.0],
        [3000.0, 4000.0],
        [3500.0, 3500.0],
        [3500.0, 3500.0],
        [3000.0, 4000.0],
        [2000.0, 4000.0],
        [2000.0, 4000.0],
        [4000.0]
        ]

εOpt = [[0.05, 0.1],
        [0.075, 0.075],
        [0.05, 0.1],
        [0.075, 0.075],
        [0.1, 0.05],
        [0.1, 0.1],
        [0.1, 0.05],
        [0.1]
]

λOpt = [λsOptimized(v, cOpt[1], εOpt[1], 2),
        λsOptimized(v, cOpt[2], εOpt[2], 2),
        λsOptimized(v, cOpt[3], εOpt[3], 2),
        λsOptimized(v, cOpt[4], εOpt[4], 2),
        λsOptimized(v, cOpt[5], εOpt[5], 2),
        λsOptimized(v, cOpt[6], εOpt[6], 2),
        λsOptimized(v, cOpt[7], εOpt[7], 2),
        λsOptimized(v, cOpt[8], εOpt[8], 1)
        ]

println("\nIdeal velocity = $(v):")
for (number, λ) in enumerate(λOpt)
        println("\n$(number). n = $(length(λ)), c = $(cOpt[number]), ε = $(εOpt[number])")
        println("λ = $(λ)")
        println("r = $(rsOptimized(λ, εOpt[number], length(λ)))")
        println("G = $(coefG(λ))")
end
