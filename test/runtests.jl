using Test

include("setup.jl")

@testset "All the tests" begin
    include("bitmap-tests.jl")
end
