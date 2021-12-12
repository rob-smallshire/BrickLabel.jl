using Test

using Images
using BrickLabel

@testset "bitmap result has same size as argument" begin
    color_image = load("images/3009.png")
    @assert !isnothing(color_image)
    bitmap_image = bitmap(color_image)
    @test size(color_image) == size(bitmap_image)
end

@testset "padded bitmap result has border" begin
    color_image = load("images/3009.png")
    @assert !isnothing(color_image)
    bitmap_image = bitmap(color_image)
    padded_bitmap_image = pad(bitmap_image, 24)
    @test size(color_image) .+ 2*24 == size(padded_bitmap_image)
end
