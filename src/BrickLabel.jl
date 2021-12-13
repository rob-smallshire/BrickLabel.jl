module BrickLabel

using Images

export bitmap, pad, distance_contour, boundary, remove_holes, crop_limits, tight_crop

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

function crop_limits(image::AbstractArray)
    ax = axes(image)
    i_min = firstindex(ax[1])
    i_max = lastindex(ax[1])
    for i in i_min:i_max
        i_min = i
        if any(image[i,:])
            break
        end
    end
    for i in i_max:-1:i_min
        i_max = i
        if any(image[i,:])
            break
        end
    end

    j_min = firstindex(ax[2])
    j_max = lastindex(ax[2])
    for j in j_min:j_max
        j_min = j
        if any(image[:,j])
            break
        end
    end
    for j in j_max:-1:j_min
        j_max = j
        if any(image[:,j])
            break
        end
    end
    (i_min:i_max, j_min:j_max)
end

function tight_crop(image::AbstractArray)
    image[crop_limits(image)...]
end 

function boundary(image::AbstractArray, distance=24, threshold=0.99)
    b = bitmap(image, threshold)
    p = pad(b, distance)
    w = remove_holes(p)
    d = distance_contour(w, distance)
    c = tight_crop(d)
    return c
end

end # module
