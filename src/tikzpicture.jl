# Adapted from "Example: Neural network" by Kjell Magne Fauske:
# https://texample.net/tikz/examples/neural-network/
# which is licensed under CC BY 2.5:
# https://creativecommons.org/licenses/by/2.5/

TikzPicture(
    chain::Chain;
    inputs::Vector{String}=Vector{String}(),
    outputs::Vector{String}=Vector{String}(),
    outputname="Output",
    kwargs...,
) = TikzPicture(Network(chain, inputs, outputs, outputname), kwargs...)

function TikzPicture(network::Network; xscale=1.3, yscale=1, options="", kwargs...)
    inputs = network.inputs
    outputs = network.outputs
    widths = [layer.inputs for layer in network.layers]
    names = [layer.name for layer in network.layers]

    nndepth = length(network.layers)
    nnwidth = maximum(widths)

    x(i) = xscale * i
    y(i, width) = yscale * (0.5 + 0.5width - i)

    xstart = 0
    xend = x(nndepth - 1)
    ystart = -y(1, nnwidth)
    yend = y(1, nnwidth)

    yannot = yend + 1

    xymin = (xstart - 2, ystart - 1)
    xymax = (xend + 2, yend + 1.75)

    tuplefmt((a, b)) = "$a/$b"
    inputfmt((j, (y, input))) = "$j/$y/\\pgftext[right] {$input}"
    layerfmt((i, (x, hiddenlist))) = "$(i + 1)/$x/{$hiddenlist}"
    outputfmt((j, (y, output))) = "$j/$y/\\pgftext[left] {$output}"
    connectfmt((i, layerconnect)) = "$i/$(i + 1)/{$layerconnect}"
    annotfmt((x, txt)) = "$x/$txt"

    hiddenlist(width) = join(tuplefmt.(enumerate(y.(1:width, width))), ',')
    connectlist(layer) = join(tuplefmt.(layer.connect), ',')

    inputlist = join(inputfmt.(enumerate(zip(y.(1:widths[1], widths[1]), inputs))), ',')
    hiddenlists = join(layerfmt.(enumerate(zip(x.(eachindex(widths[2:end - 1])), hiddenlist.(widths[2:end - 1])))), ',')
    outputlist = join(outputfmt.(enumerate(zip(y.(1:widths[end], widths[end]), outputs))), ',')
    connectlists = join(connectfmt.(enumerate(connectlist.(network.layers))), ',')
    annotlist = join(annotfmt.(zip(x.(0:length(network.layers) - 1), names)), ',')

    data = """
        \\fill[white, use as bounding box] $xymin rectangle $xymax;

        \\foreach \\j/\\y/\\input in {$inputlist}
            \\node[input neuron,pin=left:\\input] (1-\\j) at (0,\\y) {};

        \\foreach \\i/\\x/\\hiddenlist in {$hiddenlists}
            \\foreach \\j/\\y in \\hiddenlist
                \\node[hidden neuron] (\\i-\\j) at (\\x,\\y) {};

        \\foreach \\j/\\y/\\output in {$outputlist}
            \\node[output neuron,pin=right:\\output] ($nndepth-\\j) at ($xend,\\y) {};

        \\foreach \\i/\\k/\\connectlist in {$connectlists}
            \\foreach \\j/\\l in \\connectlist
                \\path (\\i-\\j) edge (\\k-\\l);

        \\foreach \\x/\\txt in {$annotlist}
            \\node[annot] at (\\x,$yannot) {\\txt};
    """
    options = """
        neuron/.style={circle,draw,minimum size=17pt},
        input neuron/.style={neuron,fill=green!50},
        hidden neuron/.style={neuron,fill=blue!50},
        output neuron/.style={neuron,fill=red!50},
        annot/.style={text width=4em, align=center},
        $(isempty(options) ? '%' : options)
    """
    TikzPicture(data; options=options, kwargs...)
end
