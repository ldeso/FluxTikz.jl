module FluxTikz

using Flux: Chain
import TikzPictures: TikzPicture
export TikzPicture

include("layer.jl")
include("network.jl")
include("tikzpicture.jl")

end
