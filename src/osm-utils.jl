struct OSMNodeParend
    ways::Dict{Int64, Vector}
    relations::Dict{Int64, Vector}

    OSMNodeParend() = new(Dict(), Dict())
end

struct OSMWayParend
    relations::Dict{Int64, Vector}

    OSMWayParend() = new(Dict())
end

struct OSMRelationParend
    relations::Dict{Int64, Vector}

    OSMRelationParend() = new(Dict())
end

struct OSMParend
    nodes::Union{OSMNodeParend,Nothing}
    ways::Union{OSMWayParend,Nothing}
    relations::Union{OSMRelationParend,Nothing}

    OSMParend() = new(OSMNodeParend(), OSMWayParend(), OSMRelationParend())
end

function find_parends(map::OpenStreetMap)::OSMParend
    parends = OSMParend()
    # Relations
    for (k, v) in map.relations
        for (i, j) in zip(v.refs, v.types)
            if j == "node"
                if haskey(parends.nodes.relations, i)
                    push!(parends.nodes.relations[i], k)
                else
                    parends.nodes.relations[i] = [k]
                end
            elseif j == "way"
                if haskey(parends.ways.relations, i)
                    push!(parends.ways.relations[i], k)
                else
                    parends.ways.relations[i] = [k]
                end
            elseif j == "relation"
                if haskey(parends.relations.relations, i)
                    push!(parends.relations.relations[i], k)
                else
                    parends.relations.relations[i] = [k]
                end
            end
        end
    end
    # Ways
    for (k, v) in map.ways
        for i in v.refs
            if haskey(parends.nodes.ways, i)
                push!(parends.nodes.ways[i], k)
            else
                parends.nodes.ways[i] = [k]
            end
        end
    end
    return parends
end
