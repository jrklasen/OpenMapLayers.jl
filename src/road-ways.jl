struct RoadWayAttribute
    name::Union{String,Nothing}
    name_en::Union{String,Nothing}
    # road type
    roadtype::Union{Symbol,Nothing}
    # direction
    oneway::Symbol
    # # foot / wheelchair
    # footway_left::Bool
    # footway_left_opposite::Bool
    # footway_right::Bool
    # footway_right_opposite::Bool
    # bicycle
    cycleway_left::Symbol
    cycleway_left_opposite::Bool
    cycleway_right::Symbol
    cycleway_right_opposite::Bool
    # road lanes
    lanes_forward::Union{Int8,Nothing}
    lanes_backward::Union{Int8,Nothing}
    turn_lanes_forward::Union{Array,Nothing}
    turn_lanes_backward::Union{Array,Nothing}
    # shoulders
    shoulder_left::Bool
    shoulder_right::Bool
    # road attributes
    bridge::Bool
    tunnel::Bool
    # access
    private_access::Bool
    # by foot
    foot_forward::Bool
    foot_backward::Bool
    # by wheelchair
    wheelchair_forward::Bool
    wheelchair_backward::Bool
    # by bicycle
    bicycle_forward::Bool
    bicycle_backward::Bool
    # by car
    car_forward::Bool
    car_backward::Bool
end


function road_way_attributes(tags::Union{Dict,Nothing})::Union{RoadWayAttribute,Nothing}
    if tags === nothing || !haskey(tags, "highway")
        return nothing
    end

    # set a name if one exists
    name = get(tags, "name", nothing)
    name_en = get(tags, "name:en", name)

    road_type = way_roadtype(tags)
    if road_type === nothing
        return nothing
    end

    foot_access = way_foot_access(tags)
    # todo check steps etc
    wheelchair_forward = get(WHEELCHAIR_ACCESS, get(tags, "wheelchair", ""), foot_access[:foot_forward])
    wheelchair_backward = get(WHEELCHAIR_ACCESS, get(tags, "wheelchair", ""), foot_access[:foot_backward])
    bicycle_access = way_bicycle_access(tags)
    car_access = way_car_access(tags)

    roundabout = get(tags, "junction", "") == "roundabout" || get(tags, "junction", "") == "circular"
    oneway = get(ONEWAY_DIRECTION, get(tags, "oneway", ""), roundabout ? :forward : :both)

    private_access = get(PRIVAT_ACCESS, get(tags, "access", ""), false)

    bridge = get(BRIDGE, get(tags, "bridge", ""), false)
    tunnel = get(TUNNEL, get(tags, "tunnel", ""), false)

    cycleway = way_cycleway(tags, foot_access, bicycle_access)

    lanes = way_lanes(tags, oneway)
    turn_lanes = way_turn_lanes(tags, oneway)
    shoulder = way_shoulder(tags)

    attr = RoadWayAttribute(
        name,
        name_en,
        road_type,
        oneway,
        # footway_left::Bool
        # footway_left_opposite::Bool
        # footway_right::Bool
        # footway_right_opposite::Bool
        cycleway[:cycleway_left],
        cycleway[:cycleway_left_opposite],
        cycleway[:cycleway_right],
        cycleway[:cycleway_right_opposite],
        lanes[:lanes_forward],
        lanes[:lanes_backward],
        turn_lanes[:turn_lanes_forward],
        turn_lanes[:turn_lanes_backward],
        shoulder[:shoulder_left],
        shoulder[:shoulder_right],
        bridge,
        tunnel,
        private_access,
        foot_access[:foot_forward],
        foot_access[:foot_backward],
        wheelchair_forward,
        wheelchair_backward,
        bicycle_access[:bicycle_forward],
        bicycle_access[:bicycle_backward],
        car_access[:car_forward],
        car_access[:car_backward],
    )
    return attr
end


function way_roadtype(tags::Dict{String,String})::Union{Symbol,Nothing}
    if tags === nothing
        return nothing
    end

    use = get(ROAD_CLASS, get(tags, "highway", ""), nothing)
    if get(tags, "highway", "") == "construction"
        use = get(ROAD_CLASS, get(tags, "construction", ""), nothing)
    end

    if get(tags, "route", "") == "ferry" &&  haskey(tags, "motor_vehicle") && get(tags, "motor_vehicle", "") !== "no"
        use = :farry
    end

    if get(tags, "service", "") == "driveway"
        use = :driveway
    elseif get(tags, "service", "") == "alley"
        use = :alley
    elseif get(tags, "service", "") == "parking_aisle"
        use = :parking_aisle
    elseif get(tags, "service", "") == "emergency_access"
        use = :emergency_access
    elseif get(tags, "service", "") == "drive-through"
        use = :drive_through
    end

    if haskey(tags, "highway") && get(tags, "highway", "") != "construction" &&
        (get(tags, "access", "") == "emergency" || get(tags, "emergency", "") == "yes")
        use = :emergency_access
    end

    if haskey(tags, "highway")
        if get(tags, "highway", "") == "construction"
            use = :construction
        elseif get(tags, "highway", "") == "track"
            use = :track
        elseif get(tags, "highway", "") == "living_street"
            use = :living_street
        elseif use === nothing && get(tags, "highway", "") == "service"
            use = :service
        elseif get(tags, "highway", "") == "busway" || get(tags, "highway", "") == "bus_guideway"
            use = :busway
        elseif get(tags, "highway", "") == "cycleway" && get(tags, "bicycle_road", "") == "yes"
            use = :bicycle_road
        elseif get(tags, "highway", "") == "cycleway"
            use = :cycleway
        elseif get(tags, "highway", "") == "path"
            use = :path
        elseif get(tags, "highway", "") == "footway" && get(tags, "footway", "") == "sidewalk"
            use = :sidewalk
        elseif get(tags, "highway", "") == "footway" && get(tags, "footway", "") == "crossing"
            use = :crosswalk
        elseif get(tags, "highway", "") == "footway"
            use = :footway
        elseif get(tags, "highway", "") == "pedestrian"
            use = :pedestrian
        elseif get(tags, "highway", "") == "corridor"
            use = :corridor
        elseif get(tags, "highway", "") == "elevator"
            use = :elevator
        elseif get(tags, "highway", "") == "steps" && haskey(tags, "conveying") && get(tags, "conveying", "") != "no"
            use = :escalator
        elseif get(tags, "highway", "") == "steps"
            use = :stairway
        elseif get(tags, "highway", "") == "via_ferrata"
            use = :via_ferrata
        elseif get(tags, "highway", "") == "bridleway"
            use = :bridleway
        elseif get(tags, "highway", "") == "raceway"
            use = :raceway
        end
    end
    return use
end


function way_foot_access(tags::Dict{String,String})::Dict{Symbol,Bool}
    foot_forward = get(HIGHWAY_FOOT_ACCESS, get(tags, "highway", ""), nothing)
    if get(tags, "highway", "") == "construction" && haskey(HIGHWAY_FOOT_ACCESS, get(tags, "construction", ""))
        foot_forward = HIGHWAY_FOOT_ACCESS[get(tags, "construction", "")]
    end
    foot_backward = false
    foot_tag = false
    if foot_forward !== nothing
        if !get(ACCESS, get(tags, "access", ""), true) || get(tags, "impassable", "") == "yes" ||
            (get(tags, "access", "") == "private" &&
             (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
            foot_forward = false
            foot_backward = false
        end
        #check for ped overrides
        if haskey(FOOT_ACCESS, get(tags, "foot", ""))
            foot_forward = FOOT_ACCESS[get(tags, "foot", "")]
            foot_tag = true
        elseif haskey(FOOT_ACCESS, get(tags, "foot", ""))
            foot_forward = FOOT_ACCESS[get(tags, "foot", "")]
            foot_tag = true
        end
    else
        if (get(tags, "route", "") != "ferry" && get(tags, "route", "") != "shuttle_train") ||
            get(tags, "impassable", "") == "yes" || !get(ACCESS, get(tags, "access", ""), false) ||
            (get(tags, "access", "") == "private" &&
             (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
            foot_forward = false
            foot_backward = false
        else
            #check for ped overrides
            if haskey(FOOT_ACCESS, tags["foot"])
                foot_forward = FOOT_ACCESS[tags["foot"]]
                foot_tag = true
            elseif haskey(FOOT_ACCESS, tags["foot"])
                foot_forward = FOOT_ACCESS[tags["foot"]]
                foot_tag = true
            elseif get(tags, "route", "") == "ferry"
                foot_forward = true
            else
                foot_forward = false
            end
        end
    end
    #service=driveway means all are routable
    if get(tags, "service", "") == "driveway" && !haskey(tags, "access")
        foot_forward = true
    end
    # oneway access
    if (get(tags, "oneway", "") == "yes" && get(tags, "oneway:foot", "") == "no") ||
        get(tags, "foot:backward", "") == "yes"
        foot_backward = true
    end

    if get(tags, "highway", "") == "footway" || get(tags, "highway", "") == "foot" ||
        get(tags, "highway", "") == "steps" || get(tags, "highway", "") == "path" || haskey(tags, "oneway:foot")
        if foot_backward &&
            get(ONEWAY_ACCESS, get(tags, "oneway:foot", ""), false)
                foot_forward = false
        else
            foot_forward = true
        end
    else
        foot_backward = foot_forward
    end
    if !foot_backward &&
        (!haskey(tags, "oneway:foot") || get(ONEWAY_ACCESS, get(tags, "oneway:foot", ""), true) ||
        get(tags, "oneway:foot", "") == "no")
        foot_backward = foot_forward
    end
    #flip the onewayness
    if get(tags, "oneway", "") == "-1" || get(tags, "oneway:foot", "") == "-1"
        forwards = foot_forward
        foot_forward = foot_backward
        foot_backward = forwards
    end
    return Dict{Symbol,Bool}(:foot_forward => foot_forward, :foot_backward => foot_backward, :foot_tag => foot_tag)
end



function way_bicycle_access(tags::Dict{String,String})::Dict{Symbol,Bool}
    bicycle_forward = get(HIGHWAY_BICYCLE_ACCESS, get(tags, "highway", ""), nothing)
    if get(tags, "highway", "") == "construction" && haskey(HIGHWAY_BICYCLE_ACCESS, get(tags, "construction", ""))
        bicycle_forward = HIGHWAY_BICYCLE_ACCESS[get(tags, "construction", "")]
    end
    bicycle_backward = false
    bicycle_tag = false
    if bicycle_forward !== nothing
        if !get(ACCESS, get(tags, "access", ""), true) || get(tags, "impassable", "") == "yes" ||
           (get(tags, "access", "") == "private" &&
            (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
            bicycle_forward = false
        elseif get(tags, "vehicle", "") == "no"
            bicycle_forward = false
        end
        #check for bicycle_forward overrides
        if haskey(BICYCLE_ACCESS, get(tags, "bicycle", ""))
            bicycle_forward = BICYCLE_ACCESS[get(tags, "bicycle", "")]
            bicycle_tag = true
        elseif haskey(CYCLEWAY, get(tags, "cycleway", ""))
            bicycle_forward = CYCLEWAY[get(tags, "cycleway", "")]
            bicycle_tag = true
        elseif haskey(BICYCLE_ACCESS, get(tags, "bicycle_road", ""))
            bicycle_forward = BICYCLE_ACCESS[get(tags, "bicycle_road", "")]
            bicycle_tag = true
        elseif haskey(BICYCLE_ACCESS, get(tags, "cyclestreet", ""))
            bicycle_forward = BICYCLE_ACCESS[get(tags, "cyclestreet", "")]
            bicycle_tag = true
        end
        if !bicycle_tag
            if get(tags, "sac_scale", "") == "hiking"
                bicycle_forward = true
                bicycle_tag = true
            elseif haskey(tags, "sac_scale")
                bicycle_forward = false
            end
        end
    else
        if (get(tags, "route", "") != "ferry" && get(tags, "route", "") != "shuttle_train") ||
            get(tags, "impassable", "") == "yes" || !get(ACCESS, get(tags, "access", ""), false) ||
            (get(tags, "access", "") == "private" &&
             (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
            bicycle_forward = false
        else
            #check for bicycle_forward overrides
            if haskey(BICYCLE_ACCESS, get(tags, "bicycle", ""))
                bicycle_forward = BICYCLE_ACCESS[get(tags, "bicycle", "")]
                bicycle_tag = true
            elseif haskey(CYCLEWAY, get(tags, "cycleway", ""))
                bicycle_forward = CYCLEWAY[get(tags, "cycleway", "")]
                bicycle_tag = true
            elseif haskey(BICYCLE_ACCESS, get(tags, "bicycle_road", ""))
                bicycle_forward = BICYCLE_ACCESS[get(tags, "bicycle_road", "")]
                bicycle_tag = true
            elseif haskey(BICYCLE_ACCESS, get(tags, "cyclestreet", ""))
                bicycle_forward = BICYCLE_ACCESS[get(tags, "cyclestreet", "")]
                bicycle_tag = true
            elseif get(tags, "route", "") == "ferry"
                bicycle_forward = true
            else
                bicycle_forward = false
            end
            if !bicycle_tag
                if get(tags, "sac_scale", "") == "hiking"
                    bicycle_forward = true
                    bicycle_tag = true
                elseif haskey(tags, "sac_scale")
                    bicycle_forward = false
                end
            end
        end
    end
    #service=driveway means all are routable
    if get(tags, "service", "") == "driveway" && !haskey(tags, "access")
        bicycle_forward = true
    end
    # backward access
    if (get(tags, "oneway", "") == "yes" && get(tags, "oneway:bicycle", "") == "no") ||
        get(tags, "bicycle:backward", "") == "yes" || get(tags, "bicycle:backward", "") == "no"
        bicycle_backward = true
    end
    if !bicycle_backward
        if haskey(BICYCLE_REVERSE, get(tags, "cycleway", ""))
            bicycle_backward = BICYCLE_REVERSE[tags["cycleway"]]
        elseif haskey(BICYCLE_REVERSE, get(tags, "cycleway:left", ""))
            bicycle_backward = BICYCLE_REVERSE[tags["cycleway:left"]]
        elseif haskey(BICYCLE_REVERSE, get(tags, "cycleway:right", ""))
            bicycle_backward = BICYCLE_REVERSE[tags["cycleway:right"]]
        end
    end
    # oneway access
    if get(ONEWAY_ACCESS, get(tags, "oneway", ""), false)
        if bicycle_backward
            if get(ONEWAY_ACCESS, get(tags, "oneway:bicycle", ""), false)
                bicycle_forward = false
            else
                bicycle_forward = true
            end
        end
    else !bicycle_backward && get(tags, "oneway:bicycle", "") != "-1" &&
        (!haskey(tags, "oneway:bicycle") || !get(ONEWAY_ACCESS, get(tags, "oneway:bicycle", ""), true) ||
        get(tags, "oneway:bicycle", "") == "no")
        bicycle_backward = bicycle_forward
    end
    # flip the onewayness
    if get(tags, "oneway", "") == "-1" || get(tags, "oneway:bicycle", "") == "-1"
        forwards = bicycle_forward
        bicycle_forward = bicycle_backward
        bicycle_backward = forwards
    end
    # if cycel lanes exist on both sides allow forward and backward
    if get(BICYCLE_SHARED, get(tags, "cycleway:both", ""), nothing) !== nothing ||
        get(BICYCLE_SEPARATED, get(tags, "cycleway:both", ""), nothing) !== nothing ||
        get(BICYCLE_DEDICATED, get(tags, "cycleway:both", ""), nothing) !== nothing ||

        ((get(BICYCLE_SHARED, get(tags, "cycleway:right", ""), nothing) !== nothing ||
            get(BICYCLE_SEPARATED, get(tags, "cycleway:right", ""), nothing) !== nothing ||
            get(BICYCLE_DEDICATED, get(tags, "cycleway:right", ""), nothing) !== nothing)) &&
        (get(BICYCLE_SHARED, get(tags, "cycleway:left", ""), nothing) !== nothing ||
            get(BICYCLE_SEPARATED, get(tags, "cycleway:left", ""), nothing) !== nothing ||
            get(BICYCLE_DEDICATED, get(tags, "cycleway:left", ""), nothing) !== nothing)
            bicycle_forward = true
            bicycle_backward = true
            bicycle_tag = true
        end
    return Dict{Symbol,Bool}(
        :bicycle_forward => bicycle_forward, :bicycle_backward => bicycle_backward, :bicycle_tag => bicycle_tag
    )
end


function way_car_access(tags::Dict{String,String})::Dict{Symbol,Bool}
    # basic type of road access
    car_forward = get(HIGHWAY_CAR_ACCESS, get(tags, "highway", ""), nothing)
    if get(tags, "highway", "") == "construction" && haskey(HIGHWAY_CAR_ACCESS, get(tags, "construction", ""))
        car_forward = HIGHWAY_CAR_ACCESS[get(tags, "construction", "")]
    end
    car_backward = false
    car_tag = false
    if car_forward !== nothing
        # if there is road-type based knowledge of access, we can further adjust this based on more specific tags
        if !get(ACCESS, get(tags, "access", ""), true) ||
            get(tags, "impassable", "") == "yes" ||
           (get(tags, "access", "") == "private" &&
            (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
            car_forward = false
            car_backward = false
        elseif get(tags, "vehicle", "") == "no"
            car_forward = false
            car_backward = false
        end
        # main car tags if they are given, we are quite certain
        if haskey(MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""))
            car_forward = MOTOR_VEHICLE_ACCESS[get(tags, "motorcar", "")]
            car_tag = true
        elseif haskey(MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""))
            car_forward = MOTOR_VEHICLE_ACCESS[get(tags, "motor_vehicle", "")]
            car_tag = true
        end
    else
        # if no road-type based information is given, we need to check ferries and shuttle trains
        if get(tags, "route", "") != "ferry" || get(tags, "impassable", "") == "yes" ||
            !get(ACCESS, get(tags, "access", ""), false) ||
            (get(tags, "access", "") == "private" &&
             (get(tags, "emergency", "") == "yes" || get(tags, "service", "") == "emergency_access"))
            car_forward = false
            car_backward = false
        else
            # main car tags if they are given, we are quite certain
            if haskey(MOTOR_VEHICLE_ACCESS, get(tags, "motorcar", ""))
                car_forward = MOTOR_VEHICLE_ACCESS[get(tags, "motorcar", "")]
                car_tag = true
            elseif haskey(MOTOR_VEHICLE_ACCESS, get(tags, "motor_vehicle", ""))
                car_forward = MOTOR_VEHICLE_ACCESS[get(tags, "motor_vehicle", "")]
                car_tag = true
            elseif get(tags, "vehicle", "") == "no"
                car_forward = false
                car_tag = true
            elseif get(tags, "route", "") == "ferry"
                car_forward = true
            else
                car_forward = false
            end
        end
    end
    # if no specific access tag was provided, turn access of under this conditions
    if !car_tag &&
        (get(tags, "access", "") == "permissive" || get(tags, "access", "") == "hov" ||
        get(tags, "access", "") == "taxi") &&
        get(tags, "oneway", "") == "reversible"
        car_forward = false
    end
    # if a driveway is missing a access tag allow access anyway
    if get(tags, "service", "") == "driveway" && !haskey(tags, "access")
        car_forward = true
    end
    # oneway access
    if get(
            ONEWAY_ACCESS, get(tags, "oneway", ""),
            get(tags, "junction", "") == "roundabout" || get(tags, "junction", "") == "circular"
        )
        car_backward = false
    else
        car_backward = car_forward
    end
    #flip the onewayness
    if get(tags, "oneway", "") == "-1"
        forwards = car_forward
        car_forward = car_backward
        car_backward = forwards
    end
    return Dict{Symbol,Bool}(:car_forward => car_forward, :car_backward => car_backward, :car_tag => car_tag)
end


function way_cycleway(
    tags::Dict{String,String},
    foot_access::Dict{Symbol,Bool},
    bicycle_access::Dict{Symbol,Bool}
)::Dict{Symbol,Union{Symbol, Bool}}
    cycleway_right_opposite = false
    cycleway_left_opposite = false

    cycleway_right = :none
    cycleway_left = :none

    if (get(tags, "highway", "") == "cycleway" || get(tags, "highway", "") == "footway" ||
        get(tags, "highway", "") == "path") &&
        (bicycle_access[:bicycle_forward] || bicycle_access[:bicycle_backward])
        # cycleway, footway and path road types which make the assumption of bidirectional access very likely.
        # Therefore, we can make the following assumptions
        if !foot_access[:foot_forward] && !foot_access[:foot_backward]
            cycleway_right = :separated
        elseif get(tags, "segregated", "") == "yes"
            cycleway_right = :dedicated
        elseif get(tags, "segregated", "") == "no"
            cycleway_right = :shared
        elseif get(tags, "highway", "") == "cycleway"
            cycleway_right = :dedicated
        else
            cycleway_right = :shared
        end
        cycleway_left = cycleway_right
    else
        # Set flags if any of the lanes are marked "opposite" (contraflow)
        cycleway_right_opposite = get(BICYCLE_REVERSE, get(tags, "cycleway", ""), false)
        cycleway_left_opposite = cycleway_right_opposite

        if cycleway_right_opposite == false
            cycleway_right_opposite = get(BICYCLE_REVERSE, get(tags, "cycleway:right", ""), false)
            cycleway_left_opposite = get(BICYCLE_REVERSE, get(tags, "cycleway:left", ""), false)
        end

        # Figure out which side of the road has what cycleway
        if haskey(BICYCLE_SHARED, get(tags, "cycleway", ""))
            cycleway_right = BICYCLE_SHARED[get(tags, "cycleway", "")]
        elseif haskey(BICYCLE_SEPARATED, get(tags, "cycleway", ""))
            cycleway_right = BICYCLE_SEPARATED[get(tags, "cycleway", "")]
        elseif haskey(BICYCLE_DEDICATED, get(tags, "cycleway", ""))
            cycleway_right = BICYCLE_DEDICATED[get(tags, "cycleway", "")]
        else
            cycleway_right = get(BICYCLE_BUFFER, get(tags, "cycleway:both:buffer", ""), :none)
        end
        cycleway_left = cycleway_right

        if cycleway_right == :none
            if haskey(BICYCLE_SHARED, get(tags, "cycleway:right", ""))
                cycleway_right = BICYCLE_SHARED[get(tags, "cycleway:right", "")]
            elseif haskey(BICYCLE_SEPARATED, get(tags, "cycleway:right", ""))
                cycleway_right = BICYCLE_SEPARATED[get(tags, "cycleway:right", "")]
            elseif haskey(BICYCLE_DEDICATED, get(tags, "cycleway:right", ""))
                cycleway_right = BICYCLE_DEDICATED[get(tags, "cycleway:right", "")]
            else
                cycleway_right = get(BICYCLE_BUFFER, get(tags, "cycleway:right:buffer", ""), :none)
            end
            if haskey(BICYCLE_SHARED, get(tags, "cycleway:left", ""))
                cycleway_left = BICYCLE_SHARED[get(tags, "cycleway:left", "")]
            elseif haskey(BICYCLE_SEPARATED, get(tags, "cycleway:left", ""))
                cycleway_left = BICYCLE_SEPARATED[get(tags, "cycleway:left", "")]
            elseif haskey(BICYCLE_DEDICATED, get(tags, "cycleway:left", ""))
                cycleway_left = BICYCLE_DEDICATED[get(tags, "cycleway:left", "")]
            else
                cycleway_left = get(BICYCLE_BUFFER, get(tags, "cycleway:left:buffer", ""), :none)
            end
        end

        # If there is a oneway:bicycle=no tag and there are no "opposite_lane/opposite_track" tags there are certain
        # situations where the cycleway is considered a two-way.
        oneway = get(ONEWAY_DIRECTION, get(tags, "oneway", ""),
            get(ONEWAY_DIRECTION, get(tags, "oneway:bicycle", ""), :none)
        )
        if get(tags, "oneway:bicycle", "") == "no" && !cycleway_right_opposite && !cycleway_left_opposite
            if cycleway_right == :dedicated || cycleway_right == :separated
                if oneway == :forward || oneway == :backward
                    cycleway_left = cycleway_right
                    cycleway_left_opposite = true
                elseif cycleway_left == :none
                    cycleway_left = cycleway_right
                end
            elseif cycleway_left == :dedicated || cycleway_left == :separated
                if oneway == :forward || oneway == :backward
                    cycleway_right = cycleway_left
                    cycleway_right_opposite = true
                elseif cycleway_right == :none
                    cycleway_right = cycleway_left
                end
            end
        end
    end
    cycleway = Dict{Symbol,Union{Symbol, Bool}}(
        :cycleway_left => cycleway_left,
        :cycleway_left_opposite => cycleway_left_opposite,
        :cycleway_right => cycleway_right,
        :cycleway_right_opposite => cycleway_right_opposite,
    )
    return cycleway
end

function way_lanes(tags::Dict{String,String}, oneway::Symbol)::Dict{Symbol,Union{Nothing,Int8}}
    if oneway == :both || oneway == :reversible
        lanes_forward = parse_lane_count(get(tags, "lanes:forward", nothing))
        lanes_backward = parse_lane_count(get(tags, "lanes:backward", nothing))
    elseif oneway == :worward
        lanes_forward = parse_lane_count(get(tags, "lanes:forward", nothing))
        lanes_backward = nothing
    elseif oneway == :backward
        lanes_forward = nothing
        lanes_backward = parse_lane_count(get(tags, "lanes:backward", nothing))
    else
        lanes_forward = nothing
        lanes_backward = nothing
    end
    if lanes_forward === nothing && (oneway == :both || oneway == :worward || oneway == :reversible)
        lanes = parse_lane_count(get(tags, "lanes", nothing))
        if lanes !== nothing && lanes !== missing && lanes > 1 && oneway == :both
            lanes_forward  = floor(lanes/2)
        elseif lanes !== nothing && lanes !== missing  && lanes > 1 && (oneway == :forward || oneway == :reversible)
            lanes_forward  = lanes
        elseif oneway == :forward
            lanes_forward  = lanes
        end
    end
    if lanes_backward === nothing && (oneway == :both || oneway == :backward || oneway == :reversible)
        lanes = parse_lane_count(get(tags, "lanes", nothing))
        if lanes !== nothing && lanes !== missing  && lanes > 1 && oneway == :both
            lanes_backward = floor(lanes/2)
        elseif lanes !== nothing && lanes !== missing  && lanes > 1 && (oneway == :backward || oneway == :reversible)
            lanes_backward = lanes
        elseif oneway == :backward
            lanes_backward = lanes
        end
    end
    return Dict{Symbol,Union{Nothing,Int8}}(:lanes_forward => lanes_forward, :lanes_backward => lanes_backward)
end


function way_turn_lanes(tags::Dict{String,String}, oneway::Symbol)::Dict{Symbol,Union{Array,Nothing}}
    if oneway == :both || oneway == :reversible
        turn_lanes_forward = parse_turn_lanes(get(tags, "turn:lanes:forward", nothing))
        turn_lanes_backward = parse_turn_lanes(get(tags, "turn:lanes:backward", nothing))
    elseif oneway == :worward
        turn_lanes_forward = parse_turn_lanes(get(tags, "turn:lanes:forward", nothing))
        turn_lanes_backward = nothing
    elseif oneway == :backward
        turn_lanes_forward = nothing
        turn_lanes_backward = parse_turn_lanes(get(tags, "turn:lanes:backward", nothing))
    else
        turn_lanes_forward = nothing
        turn_lanes_backward = nothing
    end
    if turn_lanes_forward === nothing  && oneway == :forward
        turn_lanes_forward = parse_turn_lanes(get(tags, "turn:lanes", nothing))
    end
    if turn_lanes_backward === nothing && oneway == :backward
        turn_lanes_backward = parse_turn_lanes(get(tags, "turn:lanes", nothing))
    end

    turn_lanes = Dict{Symbol,Union{Array, Nothing}}(
        :turn_lanes_forward => turn_lanes_forward,
        :turn_lanes_backward => turn_lanes_backward
    )
    return turn_lanes
end


function way_shoulder(tags::Dict{String,String})::Dict{Symbol,Bool}
    if haskey(SHOULDER, get(tags, "shoulder", ""))
        r_shoulder = SHOULDER[get(tags, "shoulder", "")]
    elseif haskey(SHOULDER, get(tags, "shoulder:both", ""))
        r_shoulder = SHOULDER[get(tags, "shoulder:both", "")]
    else
        r_shoulder = nothing
    end
    l_shoulder = r_shoulder
    if r_shoulder === nothing
        if haskey(SHOULDER, get(tags, "shoulder:right", ""))
            r_shoulder = SHOULDER[tags["shoulder:right"]]
        else
            r_shoulder = get(SHOULDER_RIGHT, get(tags, "shoulder", ""), false)
        end
        if haskey(SHOULDER, get(tags, "shoulder:left", ""))
            l_shoulder = SHOULDER[get(tags, "shoulder:left", "")]
        else
            l_shoulder = get(SHOULDER_LEFT, get(tags, "shoulder", ""), false)
        end
    end
    return Dict{Symbol,Bool}(:shoulder_left => l_shoulder, :shoulder_right => r_shoulder)
end
