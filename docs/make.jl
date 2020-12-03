using FluxTikz
using Documenter

makedocs(;
    modules=[FluxTikz],
    authors="Léo de Souza",
    repo="https://github.com/de-souza/FluxTikz.jl/blob/{commit}{path}#L{line}",
    sitename="FluxTikz.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://de-souza.github.io/FluxTikz.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/de-souza/FluxTikz.jl",
)
