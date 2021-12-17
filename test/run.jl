include("setup.jl")

color_images = [
    load("test/images/3004.png"),
    #load("test/images/3622.png"),
    # load("test/images/3010.png"),
    # load("test/images/3009.png"),
    # load("test/images/3008.png"),
]
println(length(color_images))
boundaries = map(boundary, color_images)
for boundary in boundaries
    println(boundary)
end
pack_boundaries(boundaries)
