struct RoadNodeAttribute
    access::Bool
    barring::Bool
    crossing::Bool
    foot::Bool
    wheelchair::Bool
    bicycle::Bool
    car::Bool
    privat::Bool
end

function road_node_attributes(tags)
    if tags === nothing
        return nothing
    end
    # general access
    access = node_access(tags)
    # barring, like gate and bollard
    barring = node_barring(tags)
    # check if the node a crossing?
    if !barring[:gate] && !barring[:bollard] && !barring[:sump_buster] && access[:access]
        crossing = get(tags, "highway", "") == "crossing" || get(tags, "railway", "") == "crossing" ||
                   get(tags, "footway", "") == "crossing" || get(tags, "cycleway", "") == "crossing" ||
                   get(tags, "foot", "") == "crossing" || get(tags, "bicycle", "") == "crossing" ||
                   get(tags, "pedestrian", "") == "crossing" || haskey(tags, "crossing")
    else
        crossing = false
    end
    # mobilety mode access
    foot_access = node_foot(tags, access, barring, crossing)
    wheelchair_access = node_wheelchair(tags, access, barring, crossing)
    bicycle_access = node_bicycle(tags, access, barring, crossing)
    car_access = node_car(tags, access, barring, crossing)
    # access to privat roads
    if haskey(PRIVAT_ACCESS, get(tags, "access", ""))
        privat = PRIVAT_ACCESS[get(tags, "access", "")]
    elseif haskey(PRIVAT_ACCESS, get(tags, "motor_vehicle", ""))
        privat = PRIVAT_ACCESS[get(tags, "motor_vehicle", "")]
    else
        privat = false
    end

    attr = RoadNodeAttribute(
        access[:access],
        barring[:gate],
        crossing,
        foot_access[:foot],
        wheelchair_access[:wheelchair],
        bicycle_access[:bicycle],
        car_access[:car],
        privat,
        )

    return attr
end

function node_access(tags)::Dict{Symbol,Bool}
    raw_access = get(tags, "access", "")
    access_tag = haskey(ACCESS, raw_access)
    access = get(ACCESS, raw_access, true)
    if get(tags, "impassable", "") == "yes" ||
       (get(tags, "access", "") == "private" &&
        (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
        access = false
    end
    return Dict{Symbol,Bool}(:access => access, :access_tag => access_tag)
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


function node_foot(
    tags::Dict{String,String},
    access::Dict{Symbol,Bool},
    barring::Dict{Symbol,Bool},
    crossing::Bool
)
    foot = get(FOOT_ACCESS, get(tags, "foot", ""), nothing)
    foot_tag = true
    # if tag is missing, try to derive access info from additional information
    if foot === nothing
        foot_tag = false
        if get(tags, "hov", "") == "designated" || !access[:access]
            foot = false
        else
            foot = true
        end
        if !barring[:gate] && barring[:bollard] && !access[:access_tag]
            foot = true
        elseif !barring[:gate] && barring[:sump_buster]
            foot = true
        end
        if crossing
            foot = true
        end
    end
    return Dict{Symbol,Bool}(:foot => foot, :foot_tag => foot_tag)
end

function node_wheelchair(
    tags::Dict{String,String},
    access::Dict{Symbol,Bool},
    barring::Dict{Symbol,Bool},
    crossing::Bool
)
    wheelchair = get(WHEELCHAIR_ACCESS, get(tags, "wheelchair", ""), nothing)
    # if wheelchair was not set and foot is
    if wheelchair === nothing && get(FOOT_ACCESS, get(tags, "foot", ""), false)
        wheelchair = true
    end
    wheelchair_tag = true
    # if tag is missing, derive access from additional information
    if wheelchair === nothing
        wheelchair_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access[:access]
            wheelchair = false
        else
            wheelchair = true
        end
        if !barring[:gate] && barring[:bollard] && !access[:access_tag]
            wheelchair = true
        elseif !barring[:gate] && barring[:sump_buster]
            wheelchair = true
        end
        if crossing
            wheelchair = true
        end
    end
    return Dict{Symbol,Bool}(:wheelchair => wheelchair, :wheelchair_tag => wheelchair_tag)
end

function node_bicycle(
    tags::Dict{String,String},
    access::Dict{Symbol,Bool},
    barring::Dict{Symbol,Bool},
    crossing::Bool
)
    bicycle = get(BICYCLE_ACCESS, get(tags, "bicycle", ""), missing)
    # do not shut off bicycle access if there is a highway crossing.
    if bicycle === missing && get(tags, "highway", "") == "crossing"
        bicycle = true
    end
    bicycle_tag = true
    # if tag is missing, derive access from additional information
    if bicycle === missing
        bicycle_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access[:access]
            bicycle = false
        else
            bicycle = true
        end
        if !barring[:gate] && barring[:bollard] && !access[:access_tag]
            bicycle = true
        elseif !barring[:gate] && barring[:sump_buster]
            bicycle = true
        end
        if crossing
            bicycle = true
        end
    end
    return Dict{Symbol,Bool}(:bicycle => bicycle, :bicycle_tag => bicycle_tag)
end

function node_car(
    tags::Dict{String,String},
    access::Dict{Symbol,Bool},
    barring::Dict{Symbol,Bool},
    crossing::Bool
)
    motor_vehicle = get(MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), missing)
    car = get(MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""), motor_vehicle)
    car_tag = true
    # if tag is missing, derive access from additional information
    if car === missing
        car_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access[:access]
            car = false
        else
            car = true
        end
        if !barring[:gate] && barring[:bollard] && !access[:access_tag]
            car = false
        elseif !barring[:gate] && barring[:sump_buster]
            car = false
        end
        if crossing
            car = true
        end
    end
    return Dict{Symbol,Bool}(:car => car, :car_tag => car_tag)
end
