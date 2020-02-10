mutable struct Stage
    mFull::Float64
    mFuel::Float64
    c::Float64
    # mFlowRate::Float64
end

mutable struct Rocket
    mPayload::Float64
    stages::Vector{Stage}
end
