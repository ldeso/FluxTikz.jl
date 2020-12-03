struct Network
    inputs::Vector{String}
    outputs::Vector{String}
    layers::Vector{Layer}
end

function Network(m::Chain, inputs::Vector{String}, outputs::Vector{String}, outputname)
    if isempty(inputs)
        inputs = repeat([""], findinputs(m))
    end
    if isempty(outputs)
        outputs = repeat([""], findoutputs(m))
    end
    layers = vcat(Layer.(m), Layer(outputname, length(outputs), 0, []))
    if layers[1].inputs == 0
        layers[1] = Layer(layers[1].name, length(inputs))
    end
    for i in eachindex(layers)[2:end - 1]
        if layers[i].inputs == 0
            layers[i] = Layer(layers[i].name, layers[i - 1].outputs)
        end
    end
    for i in eachindex(layers)[1:end - 1]
        o = layers[i].outputs
        i = layers[i + 1].inputs
        i != o && error(
            DimensionMismatch("layer A has $o outputs, layer B has $i inputs")
        )
    end
    Network(inputs, outputs, layers)
end

function findinputs(m::Chain)
    i = 1
    inputs = 0
    while inputs == 0
        inputs = Layer(m[i]).inputs
        i += 1
        if i > length(m)
            inputs = 1
        end
    end
    inputs
end

function findoutputs(m::Chain)
    i = length(m)
    outputs = 0
    while outputs == 0
        outputs = Layer(m[i]).outputs
        i -= 1
        if i < 1
            outputs = 1
        end
    end
    outputs
end
