module SpecialGraphs

import LightGraphs
const LG = LightGraphs

using LightGraphs: nv, ne, outneighbors,
                   inneighbors, vertices, edges, Edge,
                   has_vertex, has_edge

export WheelGraph, PathGraph, CompleteGraph

include("WheelGraph.jl")
include("PathGraph.jl")
include("CompleteGraph.jl")

end # module
