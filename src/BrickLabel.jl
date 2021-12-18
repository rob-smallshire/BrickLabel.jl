module BrickLabel

using Images
using Stuffing


export bitmap, pad, distance_contour, margin_mask, remove_holes, tight_crop_limits, crop_to_limits, tight_crop, pack_boundaries

function bitmap(image::AbstractArray, threshold=1.0)
    Gray.(image) .<  0.99
end

function pad_zero(image::AbstractArray, border)
    padarray(image, Fill(zero(eltype(image)),(border,border),(border,border)))
end

function pad_one(image::AbstractArray, border)
    padarray(image, Fill(one(eltype(image)),(border,border),(border,border)))
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

function tight_crop_limits(image::AbstractArray)
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

function crop_to_limits(image::AbstractArray, limits)
    image[limits...]
end

function tight_crop(image::AbstractArray)
    crop_to_limits(image, crop_limits(image))
end 

struct MaskedImage
    image::AbstractArray
    mask::BitMatrix
    MaskedImage(image, mask) = size(image) != size(mask) ? error("image and mask not equal sizes") : new(image, mask)
end

function Base.size(image::MaskedImage)
    size(image.image)
end

"""
    margin_mask(image[, [margin][, threshold])

Return a image and mask with a margin of the same size.
"""
function margin_mask(image::AbstractArray, margin=24, threshold=0.99)
    bit_image = bitmap(image, threshold)
    padded_bit_image = pad_zero(bit_image, margin)
    object_mask = remove_holes(padded_bit_image)
    margin_mask = distance_contour(object_mask, margin)
    margin_limits = tight_crop_limits(margin_mask)
    cropped_mask = crop_to_limits(margin_mask, margin_limits)

    padded_image = pad_one(image, margin)
    masked_image = object_mask .* padded_image
    cropped_image = crop_to_limits(masked_image, margin_limits)
    
    return MaskedImage(parent(cropped_image), parent(cropped_mask))
end

"""
Pack a collection of boundaries to give positions.
"""
function pack_boundaries(boundaries, width, height)
    sort!(boundaries, by=prod ∘ size, rev=true)
    mask = falses(width, height)
    qts = qtrees(boundaries, mask=mask, maskbackground=true)
    place!(qts)
    fit!(qts)
    getpositions(qts)
end

end # module
