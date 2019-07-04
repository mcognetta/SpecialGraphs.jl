
struct WheelGraph{T} <: LG.AbstractGraph{T}
    nv::Int
end

LG.edgetype(::WheelGraph) = LG.Edge{Int}
LG.is_directed(::WheelGraph) = false
LG.is_directed(::Type{WheelGraph}) = false
LG.nv(g::WheelGraph) = g.nv
LG.ne(g::WheelGraph) = (LG.nv(g)-1) * 2
LG.vertices(g::WheelGraph) = 1:LG.nv(g)

function LightGraphs.edges(g::WheelGraph)
    edges = Vector{LG.Edge{Int}}()
    # add inner edges
    for j in 1:LG.nv(g)-1
        push!(edges, LG.Edge(1, j+1))
    end
    # add perimeter
    for j in 2:LG.nv(g)-1
        push!(edges, LG.Edge(j, j+1))
    end
    push!(edges, LG.Edge(2, LG.nv(g)))
    return edges
end

function LightGraphs.outneighbors(g::WheelGraph, v)
    if v == 1
        return collect(2:LG.nv(g))
    end
    if v == 2
        return [1, 3, LG.nv(g)]
    end
    if v == LG.nv(g)
        return [1, 2, LG.nv(g)-1]
    end
    return [1, v-1, v+1]
end

LightGraphs.inneighbors(g::WheelGraph, v) = outneighbors(g, v)

LightGraphs.has_vertex(g::WheelGraph, v) = v <= LG.nv(g)

function LightGraphs.has_edge(g::WheelGraph, v1, v2)
    if v1 > v2
        return has_edge(g, v2, v1)
    end
    if !has_vertex(g, v1) || !has_vertex(g, v2)
        return false
    end
    # rayon
    if v1 == 1 && v2 > 1
        return true
    end
    # perimeter
    if v2 == v1 + 1
        return true
    end
    # boundary conditions
    if v1 == 2 && v2 == LG.nv(g)
        return true
    end
    return false
end