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

@testset "remove_holes leaves two connected components" begin
    color_image = load("images/4285b.png")
    @assert !isnothing(color_image)
    bitmap_image = bitmap(color_image)
    padded_bitmap_image = pad(bitmap_image, 24)
    without_holes = remove_holes(padded_bitmap_image)
    labels = label_components(without_holes, trues(3,3))
    components = unique(labels)
    @test length(components) == 2
end

@testset "crop_limits d" begin
    color_image = load("images/4285b.png")
    b = boundary(color_image)
    @test crop_limits(b) == (1:168, 1:238)
end

@testset "pack_boundaries" begin
    color_images = [
        load("images/3004.png"),
        load("images/3622.png"),
        load("images/3010.png"),
        load("images/3009.png"),
        load("images/3008.png"),
    ]
    boundaries = map(boundary, color_images)
    positions = pack_boundaries(boundaries, 500, 500)
    @test length(positions) == 5
end
