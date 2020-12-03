struct Layer
    name::String
    inputs::Int
    outputs::Int
    connect::Vector{Tuple{Int,Int}}
end

function Layer(layer::Any)
    if !hasproperty(layer, :W) ||!hasproperty(layer, :σ)
        error("type $(typeof(layer)) is not supported")
    end
    name = string(Base.typename(typeof(layer)))
    activation = layer.σ
    if activation !== identity
        name *= " ($activation)"
    end
    outputs, inputs = size(layer.W)
    connect = [(i, j) for i = 1:inputs for j = 1:outputs]
    Layer(name, inputs, outputs, connect)
end

Layer(layer::Function) = Layer(string(Symbol(layer)), 0, 0, [])

Layer(name::String, neurons::Int) =
    Layer(name, neurons, neurons, collect(zip(1:neurons, 1:neurons)))
