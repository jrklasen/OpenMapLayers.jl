ACCESS = Dict(
    "yes" => true,
    "private" => true,
    "no" => false,
    "permissive" => true,
    "agricultural" => false,
    "use_sidepath" => true,
    "delivery" => true,
    "designated" => true,
    "dismount" => true,
    "discouraged" => false,
    "forestry" => false,
    "destination" => true,
    "customers" => true,
    "official" => false,
    "public" => true,
    "restricted" => true,
    "allowed" => true,
    "emergency" => false,
    "psv" => false,
    "permit" => true,
    "residents" => true
)
NODE_FOOT_ACCESS = Dict{String,Int}(
    "yes" => true,
    "private" => true,
    "no" => false,
    "permissive" => true,
    "agricultural" => false,
    "use_sidepath" => true,
    "delivery" => true,
    "designated" => true,
    "discouraged" => false,
    "forestry" => false,
    "destination" => true,
    "customers" => true,
    "official" => true,
    "public" => true,
    "restricted" => true,
    "crossing" => true,
    "sidewalk" => true,
    "allowed" => true,
    "passable" => true,
    "footway" => true,
    "permit" => true,
    "residents" => true
)
NODE_WHEELCHAIR_ACCESS = Dict{String,Int}(
    "no" => false,
    "yes" => true,
    "designated" => true,
    "limited" => true,
    "official" => true,
    "destination" => true,
    "public" => true,
    "permissive" => true,
    "only" => true,
    "private" => true,
    "impassable" => false,
    "partial" => false,
    "bad" => false,
    "half" => false,
    "assisted" => true,
    "permit" => true,
    "residents" => true
)
NODE_BICYCLE_ACCESS = Dict{String,Int}(
    "yes" => true,
    "designated" => true,
    "use_sidepath" => true,
    "no" => false,
    "permissive" => true,
    "destination" => true,
    "dismount" => true,
    "lane" => true,
    "track" => true,
    "shared" => true,
    "shared_lane" => true,
    "sidepath" => true,
    "share_busway" => true,
    "none" => false,
    "allowed" => true,
    "private" => true,
    "official" => true,
    "permit" => true,
    "residents" => true
)
NODE_MOTOR_VEHICLE_ACCESS = Dict{String,Int}(
    "yes" => true,
    "private" => true,
    "no" => false,
    "permissive" => true,
    "agricultural" => false,
    "delivery" => true,
    "designated" => true,
    "discouraged" => false,
    "forestry" => false,
    "destination" => true,
    "customers" => true,
    "official" => false,
    "public" => true,
    "restricted" => true,
    "allowed" => true,
    "permit" => true,
    "residents" => true
)
NODE_MOPED_ACCESS = Dict{String,Int}(
    "yes" => true,
    "designated" => true,
    "private" => true,
    "permissive" => true,
    "destination" => true,
    "delivery" => true,
    "dismount" => true,
    "no" => false,
    "unknown" => false,
    "agricultural" => false,
    "permit" => true,
    "residents" => true
)
NODE_MOTORCYCLE_ACCESS = Dict{String,Int}(
    "yes" => true,
    "private" => true,
    "no" => false,
    "permissive" => true,
    "agricultural" => false,
    "delivery" => true,
    "designated" => true,
    "discouraged" => false,
    "forestry" => false,
    "destination" => true,
    "customers" => true,
    "official" => false,
    "public" => true,
    "restricted" => true,
    "allowed" => true
)
NODE_TAXI_ACCESS = Dict{String,Int}(
    "no" => false,
    "yes" => true,
    "designated" => true,
    "urban" => true,
    "permissive" => true,
    "restricted" => true,
    "destination" => true,
    "delivery" => false,
    "official" => false
)
NODE_PSV_ACCESS = Dict{String,Int}(
    "bus" => true,
    "no" => false,
    "yes" => true,
    "designated" => true,
    "permissive" => true,
    "true" => true,
    "true" => true
)
NODE_BUS_ACCESS = Dict{String,Int}(
    "no" => false,
    "yes" => true,
    "designated" => true,
    "urban" => true,
    "permissive" => true,
    "restricted" => true,
    "destination" => true,
    "delivery" => false,
    "official" => false,
)
NODE_TRUCK_ACCESS = Dict{String,Int}(
    "designated" => true,
    "yes" => true,
    "no" => false,
    "destination" => true,
    "delivery" => true,
    "local" => true,
    "agricultural" => false,
    "private" => true,
    "discouraged" => false,
    "permissive" => false,
    "unsuitable" => false,
    "agricultural;forestry" => false,
    "official" => false,
    "forestry" => false,
    "destination;delivery" => true,
    "permit" => true,
    "residents" => true
)

NODE_PRIVAT_ACCESS = Dict{String,Bool}(
    "private" => true,
    "destination" => true,
    "customers" => true,
    "delivery" => true,
    "permit" => true,
    "residents" => true
)


function node_road_attributes(tags)::Dict{String,Union{String,Bool}}
    node_road_tags = Dict{String,Union{String,Bool}}()
    # general access
    access = node_access(tags)
    node_road_tags["access"] = access["access"]
    # barring, like gate and bollard
    barring = node_barring(tags)
    merge!(node_road_tags, barring)
    # if a crossing grand access
    if !barring["gate"] && !gate["bollard"] && !barring["sump_buster"] && access["access"]
        crossing = get(tags, "highway", "") == "crossing" || get(tags, "railway", "") == "crossing" ||
                   get(tags, "footway", "") == "crossing" || get(tags, "cycleway", "") == "crossing" ||
                   get(tags, "foot", "") == "crossing" || get(tags, "bicycle", "") == "crossing" ||
                   get(tags, "pedestrian", "") == "crossing" || haskey(tags, "crossing")
    else
        crossing = false
    end
    # mobilety mode access
    (node_road_tags["emergency"], node_road_tags["emergency_tag"]) = node_emergency(tags, access, barring, crossing)
    (node_road_tags["foot"], node_road_tags["foot_tag"]) = node_foot(tags, access, barring, crossing)
    (node_road_tags["weelchair"], node_road_tags["weelchair_tag"]) = node_weelchair(tags, access, barring, crossing)
    (node_road_tags["bicycle"], node_road_tags["bicycle_tag"]) = node_bicycle(tags, access, barring, crossing)
    (node_road_tags["moped"], node_road_tags["moped_tag"]) = node_moped(tags, access, barring, crossing)
    (node_road_tags["motorcycle"], node_road_tags["motorcycle_tag"]) = node_motorcycle(tags, access, barring, crossing)
    (node_road_tags["car"], node_road_tags["car_tag"]) = node_car(tags, access, barring, crossing)
    (node_road_tags["hov"], node_road_tags["hov_tag"]) = node_hov(tags, access, barring, crossing)
    (node_road_tags["taxi"], node_road_tags["taxi_tag"]) = node_taxi(tags, access, barring, crossing)
    (node_road_tags["bus"], node_road_tags["bus_tag"]) = node_bus(tags, access, barring, crossing)
    (node_road_tags["truck"], node_road_tags["truck_tag"]) = node_truck(tags, access, barring, crossing)
    # checkpoint
    if get(tags, "barrier", "") == "border_control"
        node_road_tags["checkpoint"] = "border_control"
    elseif get(tags, "barrier", "") == "toll_booth"
        node_road_tags["checkpoint"] = "toll_booth"
    elseif get(tags, "highway", "") == "toll_gantry"
        node_road_tags["checkpoint"] = "toll_gantry"
    end
    # traffic signal
    if get(tags, "traffic_signals:direction", "") == "forward"
        node_road_tags["forward_signal"] = true
    end
    if get(tags, "traffic_signals:direction", "") == "backward"
        node_road_tags["backward_signal"] = true
    end
    # stop sign
    if get(tags, "highway", "") == "stop"
        if get(tags, "direction", "") == "both"
            node_road_tags["forward_stop"] = true
            node_road_tags["backward_stop"] = true
        elseif get(tags, "direction", "") == "forward"
            node_road_tags["forward_stop"] = true
        elseif get(tags, "direction", "") == "backward" || get(tags, "direction", "") == "reverse"
            node_road_tags["backward_stop"] = true
        end
    end
    # yield sign
    if get(tags, "highway", "") == "give_way"
        if get(tags, "direction", "") == "both"
            node_road_tags["forward_yield"] = true
            node_road_tags["backward_yield"] = true
        elseif get(tags, "direction", "") == "forward"
            node_road_tags["forward_yield"] = true
        elseif get(tags, "direction", "") == "backward" || get(tags, "direction", "") == "reverse"
            node_road_tags["backward_yield"] = true
        end
    end
    # access to privat roads
    if haskey(NODE_PRIVAT_ACCESS, get(tags, "access", ""))
        node_road_tags["private"] = NODE_PRIVAT_ACCESS[get(tags, "access", "")]
    elseif haskey(NODE_PRIVAT_ACCESS, get(tags, "motor_vehicle", ""))
        node_road_tags["private"] = NODE_PRIVAT_ACCESS[get(tags, "motor_vehicle", "")]
    else
        node_road_tags["private"] = false
    end
    return node_road_tags
end

function node_access(tags)::Dict{String,Bool}
    raw_access = get(tags, "access", "")
    access_tag = haskey(ACCESS, raw_access)
    access = get(ACCESS, raw_access, true)
    if get(tags, "impassable", "") == "yes" ||
       (get(tags, "access", "") == "private" &&
        (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
        access = false
    end
    return Dict{String,Bool}("access" => access, "access_tag" => access_tag)
end

function node_barring(tags)::Dict{String,Bool}
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
    return Dict{String,Bool}("gate" => gate, "bollard" => bollard, "sump_buster" => sump_buster)
end

function node_emergency(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    emergency = missing
    if get(tags, "access", "") == "emergency" || get(tags, "emergency", "") == "yes" ||
       get(tags, "service", "") == "emergency_access"
        emergency = true
    end
    emergency_tag = true
    # if tag is missing, derive access from additional information
    if emergency === missing
        emergency_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            emergency = false
        else
            emergency = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            emergency = false
        elseif !barring["gate"] && barring["sump_buster"]
            emergency = true
        end
        if crossing
            emergency = true
        end
    end
    return emergency, emergency_tag
end

function node_foot(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    foot = get(NODE_FOOT_ACCESS, get(tags, "foot", ""), missing)
    foot_tag = true
    # if tag is missing, derive access from additional information
    if foot === missing
        foot_tag = false
        if get(tags, "hov", "") == "designated" || !access["access"]
            foot = false
        else
            foot = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            foot = true
        elseif !barring["gate"] && barring["sump_buster"]
            foot = true
        end
        if crossing
            foot = true
        end
    end
    return foot, foot_tag
end

function node_weelchair(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    wheelchair = get(NODE_WHEELCHAIR_ACCESS, get(tags, "wheelchair", ""), missing)
    # if wheelchair was not set and foot is
    if wheelchair === missing && get(NODE_FOOT_ACCESS, get(tags, "foot", ""), false)
        wheelchair = true
    end
    wheelchair_tag = true
    # if tag is missing, derive access from additional information
    if wheelchair === missing
        wheelchair_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            wheelchair = false
        else
            wheelchair = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            wheelchair = true
        elseif !barring["gate"] && barring["sump_buster"]
            wheelchair = true
        end
        if crossing
            wheelchair = true
        end
    end
    return wheelchair, wheelchair_tag
end

function node_bicycle(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    bicycle = get(NODE_BICYCLE_ACCESS, get(tags, "bicycle", ""), missing)
    # do not shut off bicycle access if there is a highway crossing.
    if bicycle === missing && get(tags, "highway", "") == "crossing"
        bicycle = true
    end
    bicycle_tag = true
    # if tag is missing, derive access from additional information
    if bicycle === missing
        bicycle_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            bicycle = false
        else
            bicycle = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            bicycle = true
        elseif !barring["gate"] && barring["sump_buster"]
            bicycle = true
        end
        if crossing
            bicycle = true
        end
    end
    return bicycle, bicycle_tag
end

function node_moped(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    moped = get(NODE_MOPED_ACCESS, get(tags, "moped", ""), get(NODE_MOPED_ACCESS, get(tags, "mofa", ""), missing))
    # must shut these off if motor_vehicle = false
    if !get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), true)
        moped = moped !== missing ? moped : false
    end
    moped_tag = true
    # if tag is missing, derive access from additional information
    if moped === missing
        moped_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            moped = false
        else
            moped = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            moped = false
        elseif !barring["gate"] && barring["sump_buster"]
            moped = true
        end
        if crossing
            moped = true
        end
    end
    return moped, moped_tag
end

function node_motorcycle(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    motorcycle = get(NODE_MOTORCYCLE_ACCESS, get(tags, "motorcycle", ""), missing)
    # must shut these off if motor_vehicle = false
    if !get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), true)
        motorcycle = motorcycle !== missing ? motorcycle : false
    end
    motorcycle_tag = true
    # if tag is missing, derive access from additional information
    if motorcycle === missing
        motorcycle_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            motorcycle = false
        else
            motorcycle = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            motorcycle = false
        elseif !barring["gate"] && barring["sump_buster"]
            motorcycle = true
        end
        if crossing
            motorcycle = true
        end
    end
    return motorcycle, motorcycle_tag
end

function node_car(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    motor_vehicle = get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), missing)
    car = get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""), motor_vehicle)
    car_tag = true
    # if tag is missing, derive access from additional information
    if car === missing
        car_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            car = false
        else
            car = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            car = false
        elseif !barring["gate"] && barring["sump_buster"]
            car = false
        end
        if crossing
            car = true
        end
    end
    return car, car_tag
end

function node_hov(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    hov = missing
    if (haskey(tags, "hov") && get(tags, "hov", "") != "no") || haskey(tags, "hov:lanes") || haskey(tags, "hov:minimum")
        hov = truetruetrue
    end
    car = get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""),
        get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), false))
    if hov === missing && car
        hov = true
    end
    # must shut these off if motor_vehicle = false
    if !get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), true)
        hov = hov !== missing ? hov : false
    end
    hov_tag = true
    # if tag is missing, derive access from additional information
    if hov === missing
        hov_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            hov = false
        else
            hov = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            hov = false
        elseif !barring["gate"] && barring["sump_buster"]
            hov = false
        end
        if crossing
            hov = true
        end
    end
    return hov, hov_tag
end

function node_taxi(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    taxi = missing
    if get(tags, "access", "") == "psv"
        taxi = true
    else
        taxi = get(NODE_TAXI_ACCESS, get(tags, "taxi", ""), missing)
    end
    if taxi === missing
        taxi = get(NODE_PSV_ACCESS, get(tags, "psv", ""), missing)
    end
    car = get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""),
        get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), false))
    if taxi === missing && car
        taxi = true
    end
    # must shut these off if motor_vehicle = false
    if !get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), true)
        taxi = taxi !== missing ? taxi : false
    end
    taxi_tag = true
    # if tag is missing, derive access from additional information
    if taxi === missing
        taxi_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            taxi = false
        else
            taxi = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            taxi = false
        elseif !barring["gate"] && barring["sump_buster"]
            taxi = false
        end
        if crossing
            taxi = true
        end
    end
    return taxi, taxi_tag
end

function node_bus(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    bus = missing
    if get(tags, "access", "") == "psv"
        bus = true
    else
        bus = get(NODE_BUS_ACCESS, get(tags, "bus", ""), missing)
    end
    if bus === missing
        bus = get(NODE_PSV_ACCESS, get(tags, "psv", ""), missing)
    end
    car = get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""),
        get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), false))
    if bus === missing && car
        bus = true
    end
    # must shut these off if motor_vehicle = false
    if !get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), true)
        bus = bus !== missing ? bus : false
    end
    bus_tag = true
    # if tag is missing, derive access from additional information
    if bus === missing
        bus_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            bus = false
        else
            bus = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            bus = false
        elseif !barring["gate"] && barring["sump_buster"]
            bus = true
        end
        if crossing
            bus = true
        end
    end
    return bus, bus_tag
end

function node_truck(
    tags::Dict{String,String},
    access::Dict{String,Bool},
    barring::Dict{String,Bool},
    crossing::Bool
)
    truck = get(NODE_TRUCK_ACCESS, get(tags, "hgv", ""), missing)
    car = get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""),
        get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), false))
    if truck === missing && car
        truck = true
    end
    # must shut these off if motor_vehicle = false
    if !get(NODE_MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""), true)
        truck = truck !== missing ? truck : false
    end
    truck_tag = true
    # if tag is missing, derive access from additional information
    if truck === missing
        truck_tag = false
        if get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated" || !access["access"]
            truck = false
        else
            truck = true
        end
        if !barring["gate"] && gate["bollard"] && !access["access_tag"]
            truck = false
        elseif !barring["gate"] && barring["sump_buster"]
            truck = true
        end
        if crossing
            truck = true
        end
    end
    return truck, truck_tag
end
