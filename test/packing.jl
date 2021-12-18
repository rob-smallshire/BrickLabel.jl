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
]
sort!(masked_images, by=prod ∘ size, rev=true) # better in descending order of size

margin_masks = [item.margin_mask for item = masked_images]

# packing
qts = qtrees(margin_masks, mask=mask, maskbackground=true)
place!(qts)
fit!(qts)

# # draw
# println("visualization:")
# oqt = overlap(qts)
# println(repr("text/plain", oqt))
# # or
# println(QTrees.charimage(oqt, maxlen=97))
# # or
# using Colors
# imageof(qt) = Gray.(QTrees.decode.(qt[1]))
# imageof(oqt)

# # get layout
# println("layout:")
# positions = getpositions(qts)
# println(positions)

# println("or get layout directly")
# packing(mask, objs, maskbackground=true)
# # or
# qts = qtrees(objs, mask=mask, maskbackground=true);
# packing!(qts)
# getpositions(qts)

positions = getpositions(qts)

result = fill(RGB(1, 1, 0), m, n)
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
