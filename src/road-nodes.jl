struct RoadNodeAttribute
    access::Union{Bool,Nothing}
    foot::Union{Bool,Nothing}
    wheelchair::Union{Bool,Nothing}
    bicycle::Union{Bool,Nothing}
    car::Union{Bool,Nothing}
    privat::Bool
    barring::Bool
    crossing::Bool
end


function road_node_attributes(tags)
    if tags === nothing
        return nothing
    end
    # general access
    access = node_access(tags)
    # barring, like gate and bollard
    barring = node_barring(tags)
    # check if the node is a crossing?
    crosswalk = node_crosswalk(tags,  access, barring)
    # mobilety mode access
    foot_access = node_foot(tags, access, barring, crosswalk)
    wheelchair_access = node_wheelchair(tags, access, barring, crosswalk)
    bicycle_access = node_bicycle(tags, access, barring, crosswalk)
    car_access = node_car(tags, access, barring, crosswalk)
    # access to privat roads
    if haskey(PRIVAT_ACCESS, get(tags, "access", ""))
        privat = PRIVAT_ACCESS[get(tags, "access", "")]
    elseif haskey(PRIVAT_ACCESS, get(tags, "motor_vehicle", ""))
        privat = PRIVAT_ACCESS[get(tags, "motor_vehicle", "")]
    else
        privat = false
    end

    if access[:access] !== nothing || foot_access[:foot] !== nothing || wheelchair_access[:wheelchair] !== nothing ||
        bicycle_access[:bicycle] !== nothing || car_access[:car] !== nothing || privat || barring[:gate] || crosswalk
        attr = RoadNodeAttribute(
            access[:access],
            foot_access[:foot],
            wheelchair_access[:wheelchair],
            bicycle_access[:bicycle],
            car_access[:car],
            privat,
            barring[:gate],
            crosswalk,
        )
    else
        attr = nothing
    end

    return attr
end


function node_access(tags)::Dict{Symbol,Union{Bool,Nothing}}
    raw_access = get(tags, "access", "")
    access_tag = haskey(ACCESS, raw_access)
    access = get(ACCESS, raw_access, nothing)
    if get(tags, "impassable", "") == "yes" ||
       (get(tags, "access", "") == "private" &&
        (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
        access = false
    end
    return Dict{Symbol,Union{Bool,Nothing}}(:access => access, :access_tag => access_tag)
end


function node_barring(tags)::Dict{Symbol,Bool}
    # check for gates, bollards, and sump_busters
    gate = get(tags, "barrier", "") == "gate" || get(tags, "barrier", "") == "yes" ||
           get(tags, "barrier", "") == "lift_gate" || get(tags, "barrier", "") == "swing_gate"
    bollard = false
    sump_buster = false
    if !gate
        # if there was a bollard cars can't get through it
        bollard = get(tags, "barrier", "") == "bollard" || get(tags, "barrier", "") == "block" ||
                  get(tags, "barrier", "") == "jersey_barrier" || get(tags, "bollard", "") == "removable" || false
        # save the following as gates.
        if bollard && (get(tags, "bollard", "") == "rising")
            gate = true
            bollard = false
        end
        # if sump_buster no access for car, hov, and taxi unless a tag exists.
        sump_buster = get(tags, "barrier", "") == "sump_buster" || false
    end
    return Dict{Symbol,Bool}(:gate => gate, :bollard => bollard, :sump_buster => sump_buster)
end


function node_crosswalk(
    tags::Dict{String,String},
    access::Dict{Symbol,Union{Bool,Nothing}},
    barring::Dict{Symbol,Bool},
)::Bool
    if !barring[:gate] && !barring[:bollard] && !barring[:sump_buster] && access[:access] == true
        crosswalk = get(tags, "highway", "") == "crossing" || get(tags, "railway", "") == "crossing" ||
                   get(tags, "footway", "") == "crossing" || get(tags, "cycleway", "") == "crossing" ||
                   get(tags, "foot", "") == "crossing" || get(tags, "bicycle", "") == "crossing" ||
                   get(tags, "pedestrian", "") == "crossing" || haskey(tags, "crossing")
    else
        crosswalk = false
    end
    return crosswalk
end


function node_foot(
    tags::Dict{String,String},
    access::Dict{Symbol,Union{Bool,Nothing}},
    barring::Dict{Symbol,Bool},
    crosswalk::Bool
)::Dict{Symbol,Union{Bool,Nothing}}
    foot = get(FOOT_ACCESS, get(tags, "foot", ""), nothing)
    foot_tag = true
    # if tag is nothing, try to derive access info from additional information
    if foot === nothing
        foot_tag = false
        if get(tags, "hov", "") == "designated" || access[:access] == false
            foot = false
        end
        if !barring[:gate] && barring[:bollard] && access[:access] == false
        elseif !barring[:gate] && barring[:sump_buster]
            foot = true
        end
        if crosswalk
            foot = true
        end
    end
    return Dict{Symbol,Union{Bool,Nothing}}(:foot => foot, :foot_tag => foot_tag)
end


function node_wheelchair(
    tags::Dict{String,String},
    access::Dict{Symbol,Union{Bool,Nothing}},
    barring::Dict{Symbol,Bool},
    crosswalk::Bool
)::Dict{Symbol,Union{Bool,Nothing}}
    wheelchair = get(WHEELCHAIR_ACCESS, get(tags, "wheelchair", ""), nothing)
    # if wheelchair was not set and foot is
    if wheelchair === nothing && get(FOOT_ACCESS, get(tags, "foot", ""), false)
        wheelchair = true
    end
    wheelchair_tag = true
    # if tag is nothing, derive access from additional information
    if wheelchair === nothing
        wheelchair_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || access[:access] == false
            wheelchair = false
        end
        if !barring[:gate] && barring[:bollard] && access[:access] == false
            wheelchair = true
        elseif !barring[:gate] && barring[:sump_buster]
            wheelchair = true
        end
        if crosswalk
            wheelchair = true
        end
    end
    return Dict{Symbol,Union{Bool,Nothing}}(:wheelchair => wheelchair, :wheelchair_tag => wheelchair_tag)
end


function node_bicycle(
    tags::Dict{String,String},
    access::Dict{Symbol,Union{Bool,Nothing}},
    barring::Dict{Symbol,Bool},
    crosswalk::Bool
)::Dict{Symbol,Union{Bool,Nothing}}
    bicycle = get(BICYCLE_ACCESS, get(tags, "bicycle", ""), nothing)
    # do not shut off bicycle access if there is a highway crosswalk.
    if bicycle === nothing && get(tags, "highway", "") == "crosswalk"
        bicycle = true
    end
    bicycle_tag = true
    # if tag is nothing, derive access from additional information
    if bicycle === nothing
        bicycle_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || access[:access] == false
            bicycle = false
        end
        if !barring[:gate] && barring[:bollard] && access[:access] == false
            bicycle = true
        elseif !barring[:gate] && barring[:sump_buster]
            bicycle = true
        end
        if crosswalk
            bicycle = true
        end
    end
    return Dict{Symbol,Union{Bool,Nothing}}(:bicycle => bicycle, :bicycle_tag => bicycle_tag)
end


function node_car(
    tags::Dict{String,String},
    access::Dict{Symbol,Union{Bool,Nothing}},
    barring::Dict{Symbol,Bool},
    crosswalk::Bool
)::Dict{Symbol,Union{Bool,Nothing}}
    motor_vehicle = get(MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), nothing)
    car = get(MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""), motor_vehicle)
    car_tag = true
    # if tag is nothing, derive access from additional information
    if car === nothing
        car_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || access[:access] == false
            car = false
        end
        if !barring[:gate] && barring[:bollard] && access[:access] == false
            car = false
        elseif !barring[:gate] && barring[:sump_buster]
            car = false
        end
        if crosswalk
            car = true
        end
    end
    return Dict{Symbol,Union{Bool,Nothing}}(:car => car, :car_tag => car_tag)
end
