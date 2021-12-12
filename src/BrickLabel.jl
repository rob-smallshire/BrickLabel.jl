module BrickLabel

using Images

export bitmap, pad, distance_contour, boundary

function bitmap(image::AbstractArray, threshold=1.0)
    Gray.(image) .<  0.99
end

function pad(image::AbstractArray, border)
    padarray(image, Fill(0,(border,border),(border,border)))
end

function distance_contour(image::AbstractArray, distance)
    positions = feature_transform(image)
    distances = distance_transform(positions)
    distances .< distance
end

function remove_holes(image::AbstractArray)
    inverted = .!(image)
    labels = label_components(inverted, trues(3,3))
    origin = first.(axes(labels))
    outside_label = labels[origin...]
    map((label) -> label != outside_label, labels)
end

function boundary(image::AbstractArray, distance=24, threshold=0.99)
    b = bitmap(image, threshold)
    p = pad(b, distance)
    w = remove_holes(p)
    d = distance_contour(w, distance)
    return d
end

end # module
