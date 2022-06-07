access = Dict(
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

foot_node = Dict{String,Int}(
    "yes" => 2,
    "private" => 2,
    "no" => 0,
    "permissive" => 2,
    "agricultural" => 0,
    "use_sidepath" => 2,
    "delivery" => 2,
    "designated" => 2,
    "discouraged" => 0,
    "forestry" => 0,
    "destination" => 2,
    "customers" => 2,
    "official" => 2,
    "public" => 2,
    "restricted" => 2,
    "crossing" => 2,
    "sidewalk" => 2,
    "allowed" => 2,
    "passable" => 2,
    "footway" => 2,
    "permit" => 2,
    "residents" => 2
)

wheelchair_node = Dict{String,Int}(
    "no" => 0,
    "yes" => 256,
    "designated" => 256,
    "limited" => 256,
    "official" => 256,
    "destination" => 256,
    "public" => 256,
    "permissive" => 256,
    "only" => 256,
    "private" => 256,
    "impassable" => 0,
    "partial" => 0,
    "bad" => 0,
    "half" => 0,
    "assisted" => 256,
    "permit" => 256,
    "residents" => 256
)

bicycle_node = Dict{String,Int}(
    "yes" => 4,
    "designated" => 4,
    "use_sidepath" => 4,
    "no" => 0,
    "permissive" => 4,
    "destination" => 4,
    "dismount" => 4,
    "lane" => 4,
    "track" => 4,
    "shared" => 4,
    "shared_lane" => 4,
    "sidepath" => 4,
    "share_busway" => 4,
    "none" => 0,
    "allowed" => 4,
    "private" => 4,
    "official" => 4,
    "permit" => 4,
    "residents" => 4
)
truck_node = Dict{String,Int}(
    "designated" => 8,
    "yes" => 8,
    "no" => 0,
    "destination" => 8,
    "delivery" => 8,
    "local" => 8,
    "agricultural" => 0,
    "private" => 8,
    "discouraged" => 0,
    "permissive" => 0,
    "unsuitable" => 0,
    "agricultural;forestry" => 0,
    "official" => 0,
    "forestry" => 0,
    "destination;delivery" => 8,
    "permit" => 8,
    "residents" => 8
)

#node proc needs the same info as above but in the form of a mask so duplicate..
motor_vehicle_node = Dict{String,Int}(
    "yes" => 1,
    "private" => 1,
    "no" => 0,
    "permissive" => 1,
    "agricultural" => 0,
    "delivery" => 1,
    "designated" => 1,
    "discouraged" => 0,
    "forestry" => 0,
    "destination" => 1,
    "customers" => 1,
    "official" => 0,
    "public" => 1,
    "restricted" => 1,
    "allowed" => 1,
    "permit" => 1,
    "residents" => 1
)
moped_node = Dict{String,Int}(
    "yes" => 512,
    "designated" => 512,
    "private" => 512,
    "permissive" => 512,
    "destination" => 512,
    "delivery" => 512,
    "dismount" => 512,
    "no" => 0,
    "unknown" => 0,
    "agricultural" => 0,
    "permit" => 512,
    "residents" => 512
)
motor_cycle_node = Dict{String,Int}(
    "yes" => 1024,
    "private" => 1024,
    "no" => 0,
    "permissive" => 1024,
    "agricultural" => 0,
    "delivery" => 1024,
    "designated" => 1024,
    "discouraged" => 0,
    "forestry" => 0,
    "destination" => 1024,
    "customers" => 1024,
    "official" => 0,
    "public" => 1024,
    "restricted" => 1024,
    "allowed" => 1024
)
bus_node = Dict{String,Int}(
    "no" => 0,
    "yes" => 64,
    "designated" => 64,
    "urban" => 64,
    "permissive" => 64,
    "restricted" => 64,
    "destination" => 64,
    "delivery" => 0,
    "official" => 0,
)

taxi_node = Dict{String,Int}(
    "no" => 0,
    "yes" => 32,
    "designated" => 32,
    "urban" => 32,
    "permissive" => 32,
    "restricted" => 32,
    "destination" => 32,
    "delivery" => 0,
    "official" => 0
)
psv_bus_node = Dict{String,Int}(
    "bus" => 64,
    "no" => 0,
    "yes" => 64,
    "designated" => 64,
    "permissive" => 64,
    "1" => 64,
    "2" => 64
)

psv_taxi_node = Dict{String,Int}(
    "taxi" => 32,
    "no" => 0,
    "yes" => 32,
    "designated" => 32,
    "permissive" => 32,
    "1" => 32,
    "2" => 32
)

private = Dict{String,Bool}(
    "private" => true,
    "destination" => true,
    "customers" => true,
    "delivery" => true,
    "permit" => true,
    "residents" => true
)

function nodes_proc(tags, access=access, foot_node=foot_node, wheelchair_node=wheelchair_node, bicycle_node=bicycle_node,
    truck_node=truck_node, motor_vehicle_node=motor_vehicle_node, moped_node=moped_node, motor_cycle_node=motor_cycle_node,
    bus_node=bus_node, taxi_node=taxi_node, psv_bus_node=psv_bus_node, psv_taxi_node=psv_taxi_node, private=private)

    # if haskey(tags, "iso:3166_2")
    #     contry_iso_code = get(tags, "iso:3166_2", "")
    #     if findfirst(isequal('-'), contry_iso_code) == 3
    #         if length(contry_iso_code) == 6 || length(contry_iso_code) == 5
    #             state_iso_code = contry_iso_code[4:end]
    #         end
    #     elseif findfirst(isequal('-'), contry_iso_code) === nothing
    #         if length(contry_iso_code) == 2 || length(contry_iso_code) == 3
    #             state_iso_code = contry_iso_code
    #         elseif length(contry_iso_code) == 4 || length(contry_iso_code) == 5
    #             state_iso_code = contry_iso_code[3:end]
    #         end
    #     end
    # end

    # normalize a few tags that we care about
    initial_access = get(access, get(tags, "access", ""), nothing)
    access = initial_access !== nothing ? initial_access : true
    if get(tags, "impassable", "") == "yes" ||
       (get(tags, "access", "") == "private" &&
        (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
        access = false
    end

    hov_tag = nothing
    if (haskey(tags, "hov") && get(tags, "hov", "") != "no") || haskey(tags, "hov:lanes") || haskey(tags, "hov:minimum")
        hov_tag = 128
    end

    foot_tag = get(foot_node, get(tags, "foot", ""), nothing)
    wheelchair_tag = get(wheelchair_node, get(tags, "wheelchair", ""), nothing)
    bike_tag = get(bicycle_node, get(tags, "bicycle", ""), nothing)
    truck_tag = get(truck_node, get(tags, "hgv", ""), nothing)
    auto_tag = get(motor_vehicle_node, get(tags, "motorcar", ""), nothing)
    motor_vehicle_tag = get(motor_vehicle_node, get(tags, "motor_vehicle", ""), nothing)
    moped_tag = get(moped_node, get(tags, "moped", ""), get(moped_node, get(tags, "mofa", ""), nothing))
    motorcycle_tag = get(motor_cycle_node, get(tags, "motorcycle", ""), nothing)
    bus_tag = nothing
    taxi_tag = nothing
    if auto_tag === nothing
        auto_tag = motor_vehicle_tag
    end


    if get(tags, "access", "") == "psv"
        bus_tag = 64
        taxi_tag = 32
    else
        bus_tag = get(bus_node, get(tags, "bus", ""), nothing)
        taxi_tag = get(taxi_node, get(tags, "taxi", ""), nothing)
    end

    if bus_tag === nothing
        bus_tag = get(psv_bus_node, get(tags, "psv", ""), nothing)
    end
    # if bus was not set and car is
    if bus_tag === nothing && auto_tag == 1
        bus_tag = 64
    end

    # if wheelchair was not set and foot is
    if wheelchair_tag === nothing && foot_tag == 2
        wheelchair_tag = 256
    end

    # if hov was not set and car is
    if hov_tag === nothing && auto_tag == 1
        hov_tag = 128
    end

    if taxi_tag === nothing
        taxi_tag = get(psv_taxi_node, get(tags, "psv", ""), nothing)
    end
    # if taxi was not set and car is
    if taxi_tag === nothing && auto_tag == 1
        taxi_tag = 32
    end

    # if truck was not set and car is
    if truck_tag === nothing && auto_tag == 1
        truck_tag = 8
    end

    # must shut these off if motor_vehicle = 0
    if motor_vehicle_tag == 0
        hov_tag = hov_tag !== nothing ? hov_tag : 0
        bus_tag = bus_tag !== nothing ? bus_tag : 0
        taxi_tag = taxi_tag !== nothing ? taxi_tag : 0
        truck_tag = truck_tag !== nothing ? truck_tag : 0
        moped_tag = moped_tag !== nothing ? moped_tag : 0
        motorcycle_tag = motorcycle_tag !== nothing ? motorcycle_tag : 0
    end

    emergency_tag = nothing # implies nothing
    if get(tags, "access", "") == "emergency" || get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"
        emergency_tag = 16
    end

    # do not shut off bike access if there is a highway crossing.
    if bike_tag == 0 && get(tags, "highway", "") == "crossing"
        bike_tag = 4
    end

    # if tag exists use it, otherwise access allowed for all modes unless access = false || tags["hov"] == "designated" || tags["vehicle"] == "no")
    # if access=private use allowed modes, but consider private_access tag as true.
    auto = auto_tag !== nothing ? auto_tag : 1
    truck = truck_tag !== nothing ? truck_tag : 8
    bus = bus_tag !== nothing ? bus_tag : 64
    taxi = taxi_tag !== nothing ? taxi_tag : auto_tag !== nothing ? auto_tag : 32
    foot = foot_tag !== nothing ? foot_tag : 2
    wheelchair = wheelchair_tag !== nothing ? wheelchair_tag : 256
    bike = bike_tag !== nothing ? bike_tag : 4
    emergency = emergency_tag !== nothing ? emergency_tag : 16
    hov = hov_tag !== nothing ? hov_tag : auto_tag !== nothing ? auto_tag : 128
    moped = moped_tag !== nothing ? moped_tag : 512
    motorcycle = motorcycle_tag !== nothing ? motorcycle_tag : 1024

    # if access = false use tag if exists, otherwise no access for that mode.
    if !access || get(tags, "vehicle", "") == "no" || get(tags, "hov", "") == "designated"
        auto = auto_tag !== nothing ? auto_tag : 0
        truck = truck_tag !== nothing ? truck_tag : 0
        bus = bus_tag !== nothing ? bus_tag : 0
        taxi = taxi_tag !== nothing ? taxi_tag : 0

        # don't change ped if tags["vehicle"] == "no"
        if access == "false" || tags["hov"] == "designated"
            foot = foot_tag !== nothing ? foot_tag : 0
        end

        wheelchair = wheelchair_tag !== nothing ? wheelchair_tag : 0
        bike = bike_tag !== nothing ? bike_tag : 0
        moped = moped_tag !== nothing ? moped_tag : 0
        motorcycle = motorcycle_tag !== nothing ? motorcycle_tag : 0
        emergency = emergency_tag !== nothing ? emergency_tag : 0
        hov = hov_tag !== nothing ? hov_tag : 0
    end

    # check for gates, bollards, && sump_busters
    gate = get(tags, "barrier", "") == "gate" || get(tags, "barrier", "") == "yes" ||
           get(tags, "barrier", "") == "lift_gate" || get(tags, "barrier", "") == "swing_gate"
    bollard = false
    sump_buster = false

    if !gate
        # if there was a bollard cars can't get through it
        bollard = get(tags, "barrier", "") == "bollard" || get(tags, "barrier", "") == "block" ||
                  get(tags, "barrier", "") == "jersey_barrier" || get(tags, "bollard", "") == "removable" || false

        # if sump_buster no access for auto, hov, && taxi unless a tag exists.
        sump_buster = get(tags, "barrier", "") == "sump_buster" || false

        # save the following as gates.
        if bollard && (get(tags, "bollard", "") == "rising")
            gate = true
            bollard = false
        end

        # bollard = true shuts off access when access is not originally specified.
        if bollard && initial_access === nothing
            auto = auto_tag !== nothing ? auto_tag : 0
            truck = truck_tag !== nothing ? truck_tag : 0
            bus = bus_tag !== nothing ? bus_tag : 0
            taxi = taxi_tag !== nothing ? taxi_tag : 0
            foot = foot_tag !== nothing ? foot_tag : 2
            wheelchair = wheelchair_tag !== nothing ? wheelchair_tag : 256
            bike = bike_tag !== nothing ? bike_tag : 4
            moped = moped_tag !== nothing ? moped_tag : 0
            motorcycle = motorcycle_tag !== nothing ? motorcycle_ta : 0
            emergency = emergency_tag !== nothing ? emergency_tag : 0
            hov = hov_tag !== nothing ? hov_tag : 0
            # sump_buster = true shuts off access unless the tag exists.
        elseif sump_buster
            auto = auto_tag !== nothing ? auto_tag : 0
            truck = truck_tag !== nothing ? truck_tag : 8
            bus = bus_tag !== nothing ? bus_tag : 64
            taxi = taxi_tag !== nothing ? taxi_tag : 0
            foot = foot_tag !== nothing ? foot_tag : 2
            wheelchair = wheelchair_tag !== nothing ? wheelchair_tag : 256
            bike = bike_tag !== nothing ? bike_tag : 4
            moped = moped_tag !== nothing ? moped_tag : 512
            motorcycle = motorcycle_tag !== nothing ? motorcycle_tag : 1024
            emergency = emergency_tag !== nothing ? emergency_tag : 16
            hov = hov_tag !== nothing ? hov_tag : 0
        end
    end

    # if nothing blocks access at this node assume access is allowed.
    if !gate && !bollard && !sump_buster && access
        if get(tags, "highway", "") == "crossing" || get(tags, "railway", "") == "crossing" ||
           get(tags, "footway", "") == "crossing" || get(tags, "cycleway", "") == "crossing" ||
           get(tags, "foot", "") == "crossing" || get(tags, "bicycle", "") == "crossing" ||
           get(tags, "pedestrian", "") == "crossing" || haskey(tags, "crossing")
            auto = auto_tag !== nothing ? auto_tag : 1
            truck = truck_tag !== nothing ? truck_tag : 8
            bus = bus_tag !== nothing ? bus_tag : 64
            taxi = taxi_tag !== nothing ? taxi_tag : 32
            foot = foot_tag !== nothing ? foot_tag : 2
            wheelchair = wheelchair_tag !== nothing ? wheelchair_tag : 256
            bike = bike_tag !== nothing ? bike_tag : 4
            moped = moped_tag !== nothing ? moped_tag : 512
            motorcycle = motorcycle_tag !== nothing ? motorcycle_tag : 1024
            emergency = emergency_tag !== nothing ? emergency_tag : 16
            hov = hov_tag !== nothing ? hov_tag : 128
        end
    end

    # # store the gate && bollard info
    # tags["gate"] = tostring(gate)
    # tags["bollard"] = tostring(bollard)
    # tags["sump_buster"] = tostring(sump_buster)

    if get(tags, "barrier", "") == "border_control"
        border_control = true
    elseif get(tags, "barrier", "") == "toll_booth"
        toll_booth = true
        if is_cash_only_payment(tags)
            cash_only_toll = true
        end
    elseif get(tags, "highway", "") == "toll_gantry"
        toll_gantry = true
    elseif get(tags, "entrance", "") == "yes" && get(tags, "indoor", "") == "yes"
        building_entrance = true
    elseif get(tags, "highway", "") == "elevator"
        elevator = true
    end

    if get(tags, "amenity", "") == "bicycle_rental" || (get(tags, "shop", "") == "bicycle" && get(tags, "service:bicycle:rental", "") == "yes")
        bicycle_rental = true
    end

    if get(tags, "traffic_signals:direction", "") == "forward"
        forward_signal = true

        if !haskey(tags, "public_transport") && haskey(tags, "name")
            junction = "named"
        end
    end

    if get(tags, "traffic_signals:direction", "") == "backward"
        backward_signal = true

        if !haskey(tags, "public_transport") && haskey(tags, "name")
            junction = "named"
        end
    end

    if get(tags, "highway", "") == "stop"
        if get(tags, "direction", "") == "both"
            forward_stop = true
            backward_stop = true
        elseif get(tags, "direction", "") == "forward"
            forward_stop = true
        elseif get(tags, "direction", "") == "backward" || get(tags, "direction", "") == "reverse"
            backward_stop = true
        elseif haskey(tags, "direction") && !haskey(tags, "stop")
            highway = nothing
        end
    end

    if get(tags, "highway", "") == "give_way"
        if get(tags, "direction", "") == "both"
            forward_yield = true
            backward_yield = true
        elseif get(tags, "direction", "") == "forward"
            forward_yield = true
        elseif get(tags, "direction", "") == "backward" || get(tags, "direction", "") == "reverse"
            backward_yield = true
        elseif haskey(tags, "direction") && !haskey(tags, "give_way")
            highway = nothing
        end
    end

    if !haskey(tags, "public_transport") && haskey(tags, "name")
        if get(tags, "highway", "") == "traffic_signals"
            if get(tags, "junction", "") != "yes"
                junction = "named"
            end
        elseif get(tags, "junction", "") == "yes" || get(tags, "reference_point", "") == "yes"
            junction = "named"
        end
    end

    if haskey(private, get(tags, "access", ""))
        private = private[get(tags, "access", "")]
    elseif haskey(private, get(tags, "motor_vehicle", ""))
        private = private[get(tags, "motor_vehicle", "")]
    else
        private = false
    end

    # store a mask denoting access
    access_mask = auto | emergency | truck | bike | foot | wheelchair | bus | hov | moped | motorcycle | taxi

    # if no information about access is given.
    if initial_access === nothing && auto_tag === nothing && truck_tag === nothing && bus_tag === nothing &&
       taxi_tag === nothing && foot_tag === nothing && wheelchair_tag === nothing && bike_tag === nothing &&
       moped_tag === nothing && motorcycle_tag === nothing && emergency_tag === nothing && hov_tag === nothing
        tagged_access = 0
    else
        tagged_access = 1
    end

    return "done"
end
