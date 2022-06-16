struct RoadNode
    latlon::LatLon
    attributes::Union{RoadNodeAttribute,Nothing}
end

struct RoadWay
    child_ids::Vector{Int64}
    attributes::Union{RoadWayAttribute,Nothing}
end

struct RoadRelation
    child_ids::Vector{Int64}
    child_types::Vector{DataType}
    child_roles::Vector{Symbol}
    attributes::Union{RoadRelationAttribute,Nothing}
end

struct RoadLayer
    nodes::Dict{Int64,RoadNode}
    ways::Dict{Int64,RoadWay}
    relations::Dict{Int64,RoadRelation}

    RoadLayer() = new(Dict(), Dict(), Dict())
end

function road_layers(map::OpenStreetMap)::RoadLayer
    parends = find_parends(map)

    roads = RoadLayer()
    # Relations
    for (k, v) in map.relations
        roadlayer = road_relation_attributes(v.tags)
        if roadlayer !== nothing
            childtypes = [i == "node" ? RoadNode : (i == "way" ? RoadWay : RoadRelation) for i in v.types]
            childroles = [Symbol(i) for i in v.roles]
            roads.relations[k] = RoadRelation(v.refs, childtypes, childroles, roadlayer)
        end
    end
    # Ways
    for (k, v) in map.ways
        roadlayer = road_way_attributes(v.tags)
        if haskey(parends.ways.relations, k) && roadlayer === nothing
            roadlayer = nothing
        end
        if roadlayer !== nothing
            roads.ways[k] = RoadWay(v.refs, roadlayer)
        end
    end
    # Node
    for (k, v) in map.nodes
        roadlayer = road_node_attributes(v.tags)

        if haskey(parends.nodes.relations, k) && haskey(parends.nodes.ways, k)
            roadlayer = nothing
        end
        if roadlayer !== nothing
            roads.nodes[k] = RoadNode(v.latlon,roadlayer)
        end
    end
    return roads
end
