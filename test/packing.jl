using Stuffing
using Random
using Images
using BrickLabel

# prepare some pseudo images 
mask = falses(1000, 1000) # can be any AbstractMatrix
m, n = size(mask)

masked_images = [
    margin_mask(load("test/images/3004.png")),
    margin_mask(load("test/images/3622.png")),
    margin_mask(load("test/images/3010.png")),
    margin_mask(load("test/images/3009.png")),
    margin_mask(load("test/images/3008.png")),
    margin_mask(load("test/images/6111.png")),
    margin_mask(load("test/images/6112.png")),
    margin_mask(load("test/images/4285b.png")),
    margin_mask(load("test/images/3004.png")),
    margin_mask(load("test/images/3622.png")),
    margin_mask(load("test/images/3010.png")),
    margin_mask(load("test/images/3009.png")),
    margin_mask(load("test/images/3008.png")),
    margin_mask(load("test/images/6111.png")),
    margin_mask(load("test/images/6112.png")),
    margin_mask(load("test/images/4285b.png")),
    margin_mask(load("test/images/3622.png")),
    margin_mask(load("test/images/3010.png")),
    margin_mask(load("test/images/3009.png")),
    margin_mask(load("test/images/3008.png")),
    margin_mask(load("test/images/6111.png")),
    margin_mask(load("test/images/6112.png")),
    margin_mask(load("test/images/3832.png")),
    margin_mask(load("test/images/3958.png")),
    margin_mask(load("test/images/3649.png")),
    margin_mask(load("test/images/99773.png")),
]
sort!(masked_images, by=prod ∘ size, rev=true) # better in descending order of size

margin_masks = [item.margin_mask for item = masked_images]

# packing
qts = qtrees(margin_masks, mask=mask, maskbackground=true)
place!(qts)
fit!(qts)

positions = getpositions(qts)

result = fill(RGB(1, 1, 1), m, n)
print(positions)
for ((p, q), masked_image) in zip(positions, masked_images)
    im = masked_image.image
    mk = masked_image.object_mask

    for ci in CartesianIndices(size(im))
        i, j = Tuple(ci)
        if mk[i, j]
            result[q + i - 1, p + j - 1] = im[i, j]
        end
    end
end
result


# TODO: Resizing individual images using imresize

# TODO: Perform a bisection search to find the largest scale at which the images
#       successfully fit

# TODO: Fetch images from URLs

