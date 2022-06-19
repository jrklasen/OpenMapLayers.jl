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


function submap(
    map::OpenStreetMap,
    bottom_lat::Float64,
    left_lon::Float64,
    top_lat::Float64,
    right_lon::Float64
)::OpenStreetMap
    smallmap = OpenStreetMap()

    # parents of each element
    parents = find_parends(map)

    # find nodes within bbox
    nodekeys = Vector{Int64}()
    for (k, v) in map.nodes
        if (bottom_lat < v.latlon.lat < top_lat) && (left_lon < v.latlon.lon < right_lon)
            push!(nodekeys, k)
        end
    end
     # find requierd ways and relations
    waykeys = Vector{Int64}()
    relationkeys = Vector{Int64}()
    for inx in nodekeys
        if haskey(parents.nodes.ways, inx)
            append!(waykeys, parents.nodes.ways[inx])
        end
        if haskey(parents.nodes.relations, inx)
            append!(relationkeys, parents.nodes.relations[inx])
        end
        if haskey(parents.ways.relations, inx)
            append!(relationkeys, parents.ways.relations[inx])
        end
    end
    unique!(waykeys)
    unique!(relationkeys)
    # select ways and relations
    for wid in waykeys
        smallmap.ways[wid] = map.ways[wid]
    end
    for rid in relationkeys
        smallmap.relations[rid] = map.relations[rid]
    end

    # find all nodes for ways and relations (also outside of bbox)
    nodekeys2 = Vector{Int64}()
    for inx in waykeys
        if haskey(smallmap.ways, inx)
            append!(nodekeys2, smallmap.ways[inx].refs)
        end
        if haskey(smallmap.relations, inx)
            smallmap.relations[inx].refs
            refs = smallmap.relations[inx].refs
            refs = refs[smallmap.relations[inx].types .== "node"]
            append!(nodekeys2, refs)
        end
    end
    unique!(nodekeys2)
    # select nodes
    for nid in nodekeys2
        smallmap.nodes[nid] = map.nodes[nid]
    end

    # meta data
    for (k, v) in map.meta
        smallmap.meta[k] = v
    end
    smallmap.meta["bbox"] = BBox(bottom_lat, left_lon, top_lat, right_lon)

    return smallmap
end
