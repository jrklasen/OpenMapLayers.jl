#returns 1 if you should filter this way 0 otherwise
function filter_tags_generic(kv)

    if (get(kv, "highway", "") == "construction" && !haskey(kv, "construction")) ||
       juliaget(kv, "highway", "") == "proposed"
        return 1
    end

    #figure out what basic type of road it is
    forward = get(highway, get(kv, "highway", ""), nothing)
    if get(kv, "highway", "") == "construction" && haskey(highway, get(kv, "construction", ""))
        forward = highway[get(kv, "construction", "")]
    end
    ferry = get(kv, "route", "") == "ferry"
    rail = get(kv, "route", "") == "shuttle_train"
    access = get(access, get(kv, "access", ""), false)

    emergency_forward = false
    emergency_backward = false
    emergency_tag = nothing

    if (ferry || rail || haskey(kv, "highway"))

        if (get(kv, "access", "") == "emergency" || get(kv, "emergency", "") == "yes" ||
            get(kv, "service", "") == "emergency_access")
            emergency_forward = true
            emergency_tag = true
        end

        if get(kv, "emergency", "") == "no"
            emergency_tag = false
        end
    end

    auto_forward = false
    truck_forward = false
    bus_forward = false
    taxi_forward = false
    moped_forward = false
    motorcycle_forward = false
    pedestrian_forward = false
    bike_forward = false

    auto_backward = false
    truck_backward = false
    bus_backward = false
    taxi_backward = false
    moped_backward = false
    motorcycle_backward = false
    pedestrian_backward = false
    bike_backward = false

    auto_tag = false
    truck_tag = false
    bus_tag = false
    taxi_tag = false
    moped_tag = false
    motorcycle_tag = false
    pedestrian_tag = false
    bike_tag = false
    motorroad_tag = true

    if length(forward) > 0
        auto_forward = forward["orward"]
        truck_forward = forward["truck_forward"]
        bus_forward = forward["bus_forward"]
        taxi_forward = forward["taxi_forward"]
        moped_forward = forward["moped_forward"]
        motorcycle_forward = forward["motorcycle_forward"]
        pedestrian_forward = forward["pedestrian_forward"]
        bike_forward = forward["bike_forward"]

        if !access || get(kv, "impassable", "") == "yes" ||
           (get(kv, "access", "") == "private" &&
            (get(kv, "emergency", "") == "yes" || get(kv, "service", "") == "emergency_access"))

            auto_forward = false
            truck_forward = false
            bus_forward = false
            taxi_forward = false
            moped_forward = false
            motorcycle_forward = false
            pedestrian_forward = false
            bike_forward = false

            auto_backward = false
            truck_backward = false
            bus_backward = false
            taxi_backward = false
            moped_backward = false
            motorcycle_backward = false
            pedestrian_backward = false
            bike_backward = false
        elseif get(kv, "vehicle", "") == "no" #don't change ped access.
            auto_forward = false
            truck_forward = false
            bus_forward = false
            taxi_forward = false
            moped_forward = false
            motorcycle_forward = false
            bike_forward = false

            auto_backward = false
            truck_backward = false
            bus_backward = false
            taxi_backward = false
            moped_backward = false
            motorcycle_backward = false
            bike_backward = false
        end

        #check for auto_forward overrides
        if haskey(motor_vehicle, get(kv, "motorcar", ""))
            auto_forward = motor_vehicle[get(kv, "motorcar", "")]
            auto_tag = true
        elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
            auto_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
            auto_tag = true
        end

        #check for truck_forward override
        if haskey(truck, get(kv, "hgv", ""))
            truck_forward = truck[get(kv, "hgv", "")]
            truck_tag = true
        elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
            truck_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
            truck_tag = true
        end

        #check for bus_forward overrides
        if haskey(bus, get(kv, "bus", ""))
            bus_forward = bus[kv["bus"]]
            bus_tag = true
        elseif haskey(psv, get(kv, "psv", ""))
            bus_forward = psv[get(kv, "psv", "")]
            bus_tag = true
        elseif haskey(psv, get(kv, "lanes:psv:forward", ""))
            bus_forward = psv[get(kv, "lanes:psv:forward", "")]
            bus_tag = true
        elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
            bus_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
            bus_tag = true
        end
        if get(kv, "access", "") == "psv"
            bus_forward = true
            bus_tag = true
        end

        #check for taxi_forward overrides
        if haskey(taxi, get(kv, "taxi", ""))
            taxi_forward = taxi[get(kv, "taxi", "")]
            taxi_tag = true
        elseif haskey(psv, get(kv, "psv", ""))
            taxi_forward = psv[get(kv, "psv", "")]
            taxi_tag = true
        elseif haskey(psv, get(kv, "lanes:psv:forward", ""))
            taxi_forward = psv[get(kv, "lanes:psv:forward", "")]
            taxi_tag = true
        elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
            taxi_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
            taxi_tag = true
        end
        if get(kv, "access", "") == "psv"
            taxi_forward = true
            taxi_tag = true
        end

        #check for ped overrides
        if haskey(foot, get(kv, "foot", ""))
            pedestrian_forward = foot[get(kv, "foot", "")]
            pedestrian_tag = true
        elseif haskey(foot, get(kv, "pedestrian", ""))
            pedestrian_forward = foot[get(kv, "pedestrian", "")]
            pedestrian_tag = true
        end

        #check for bike_forward overrides
        if haskey(bicycle, get(kv, "bicycle", ""))
            bike_forward = bicycle[get(kv, "bicycle", "")]
            bike_tag = true
        elseif haskey(cycleway, get(kv, "cycleway", ""))
            bike_forward = cycleway[get(kv, "cycleway", "")]
            bike_tag = true
        elseif haskey(bicycle, get(kv, "bicycle_road", ""))
            bike_forward = bicycle[get(kv, "bicycle_road", "")]
            bike_tag = true
        elseif haskey(bicycle, get(kv, "cyclestreet", ""))
            bike_forward = bicycle[get(kv, "cyclestreet", "")]
            bike_tag = true
        end
        if !bike_tag
            if get(kv, "sac_scale", "") == "hiking"
                bike_forward = true
                bike_tag = true
            elseif haskey(kv, "sac_scale")
                bike_forward = false
            end
        end

        #check for moped forward overrides
        if haskey(moped, get(kv, "moped", ""))
            moped_forward = moped[get(kv, "moped", "")]
            moped_tag = true
        elseif haskey(moped, get(kv, "mofa", ""))
            moped_forward = moped[get(kv, "mofa", "")]
            moped_tag = true
        elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
            moped_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
            moped_tag = true
        end

        #check for motorcycle forward overrides
        if haskey(motor_vehicle, get(kv, "motorcycle", ""))
            motorcycle_forward = motor_vehicle[get(kv, "motorcycle", "")]
            motorcycle_tag = true
        elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
            motorcycle_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
            motorcycle_tag = true
        end

        if get(kv, "motorroad", "") == "yes"
            motorroad_tag = true
        end

    else
        #if its a ferry && these tagsnt show up we want to set them to true
        default_val = ferry
        if !ferry && rail
            default_val = rail
        end

        if ((!ferry && !rail) || get(kv, "impassable", "") == "yes" || !access ||
            (get(kv, "access", "") == "private" &&
             (get(kv, "emergency", "") == "yes" || get(kv, "service", "") == "emergency_access")))

            auto_forward = false
            truck_forward = false
            bus_forward = false
            taxi_forward = false
            moped_forward = false
            motorcycle_forward = false
            pedestrian_forward = false
            bike_forward = false

            auto_backward = false
            truck_backward = false
            bus_backward = false
            taxi_backward = false
            moped_backward = false
            motorcycle_backward = false
            pedestrian_backward = false
            bike_backward = false

        else
            #check for auto_forward overrides
            if haskey(motor_vehicle, get(kv, "motorcar", ""))
                auto_forward = motor_vehicle[get(kv, "motorcar", "")]
                auto_tag = true
            elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
                auto_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
                auto_tag = true
            elseif get(kv, "vehicle", "") == "no"
                auto_forward = false
                auto_tag = true
            else
                auto_forward = default_val
            end

            #check for truck_forward override
            if haskey(truck, get(kv, "hgv", ""))
                truck_forward = truck[get(kv, "hgv", "")]
                truck_tag = true
            elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
                truck_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
                truck_tag = true
            elseif get(kv, "vehicle", "") == "no"
                auto_forward = false
                auto_tag = true
            else
                truck_forward = default_val
            end

            #check for bus_forward overrides
            if haskey(bus, get(kv, "bus", ""))
                bus_forward = bus[get(kv, "bus", "")]
                bus_tag = true
            elseif haskey(psv, get(kv, "psv", ""))
                bus_forward = psv[get(kv, "psv", "")]
                bus_tag = true
            elseif haskey(psv, get(kv, "lanes:psv:forward", ""))
                bus_forward = psv[get(kv, "lanes:psv:forward", "")]
                bus_tag = true
            elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
                bus_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
                bus_tag = true
            elseif get(kv, "access", "") == "psv"
                bus_forward = true
                bus_tag = true
            elseif get(kv, "vehicle", "") == "no"
                auto_forward = false
                auto_tag = true
            else
                bus_forward = default_val
            end

            #check for taxi_forward overrides
            if haskey(taxi, get(kv, "taxi", ""))
                taxi_forward = taxi[get(kv, "taxi", "")]
                taxi_tag = true
            elseif haskey(psv, get(kv, "psv", ""))
                taxi_forward = psv[get(kv, "psv", "")]
                taxi_tag = true
            elseif haskey(psv, get(kv, "lanes:psv:forward", ""))
                taxi_forward = psv[get(kv, "lanes:psv:forward", "")]
                taxi_tag = true
            elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
                taxi_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
                taxi_tag = true
            elseif get(kv, "access", "") == "psv"
                taxi_forward = true
                taxi_tag = true
            elseif get(kv, "vehicle", "") == "no"
                auto_forward = false
                auto_tag = true
            else
                taxi_forward = default_val
            end

            #check for ped overrides
            if haskey(foot, kv["foot"])
                pedestrian_forward = foot[kv["foot"]]
                pedestrian_tag = true
            elseif haskey(foot, kv["pedestrian"])
                pedestrian_forward = foot[kv["pedestrian"]]
                pedestrian_tag = true
            else
                pedestrian_forward = default_val
            end

            #check for bike_forward overrides
            if haskey(bicycle, get(kv, "bicycle", ""))
                bike_forward = bicycle[get(kv, "bicycle", "")]
                bike_tag = true
            elseif haskey(cycleway, get(kv, "cycleway", ""))
                bike_forward = cycleway[get(kv, "cycleway", "")]
                bike_tag = true
            elseif haskey(bicycle, get(kv, "bicycle_road", ""))
                bike_forward = bicycle[get(kv, "bicycle_road", "")]
                bike_tag = true
            elseif haskey(bicycle, get(kv, "cyclestreet", ""))
                bike_forward = bicycle[get(kv, "cyclestreet", "")]
                bike_tag = true
            else
                bike_forward = default_val
            end
            if !bike_tag
                if get(kv, "sac_scale", "") == "hiking"
                    bike_forward = true
                    bike_tag = true
                elseif haskey(kv, "sac_scale")
                    bike_forward = false
                end
            end

            #check for moped forward overrides
            if haskey(moped, get(kv, "moped", ""))
                moped_forward = moped[get(kv, "moped", "")]
                moped_tag = true
            elseif haskey(moped, get(kv, "mofa", ""))
                moped_forward = moped[get(kv, "mofa", "")]
                moped_tag = true
            elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
                moped_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
                moped_tag = true
            elseif get(kv, "vehicle", "") == "no"
                auto_forward = false
                auto_tag = true
            else
                moped_forward = default_val
            end

            #check for motorcycle forward overrides
            if haskey(motor_vehicle, get(kv, "motorcycle", ""))
                motorcycle_forward = motor_vehicle[get(kv, "motorcycle", "")]
                motorcycle_tag = true
            elseif haskey(motor_vehicle, get(kv, "motor_vehicle", ""))
                motorcycle_forward = motor_vehicle[get(kv, "motor_vehicle", "")]
                motorcycle_tag = true
            elseif get(kv, "vehicle", "") == "no"
                auto_forward = false
                auto_tag = true
            else
                motorcycle_forward = default_val
            end

            if get(kv, "motorroad", "") == "yes"
                kv["motorroad_tag"] = true
            end
        end
    end

    #TODO: handle Time conditional restrictions if available for HOVs with oneway = reversible
    if ((get(kv, "access", "") == "permissive" || get(kv, "access", "") == "hov" ||
         get(kv, "access", "") == "taxi") &&
        get(kv, "oneway", "") == "reversible")

        # for now enable only for buses if the tag exists and they are allowed.
        if bus_forward
            auto_forward = false
            truck_forward = false
            pedestrian_forward = false
            bike_forward = false
            moped_forward = false
            motorcycle_forward = false
        else
            # by returning 1 we will toss this way
            return 1
        end
    end

    #service=driveway means all are routable
    if get(kv, "service", "") == "driveway" && !haskey(kv, "access")
        auto_forward = true
        truck_forward = true
        bus_forward = true
        taxi_forward = true
        pedestrian_forward = true
        bike_forward = true
        moped_forward = true
        motorcycle_forward = true
    end

    #check the oneway-ness && traversability against the direction of the geom
    if ((get(kv, "oneway", "") == "yes" && get(kv, "oneway:bicycle", "") == "no") ||
        get(kv, "bicycle:backward", "") == "yes" || get(kv, "bicycle:backward", "") == "no")
        bike_backward = true
    end
    if !bike_backward
        if haskey(bike_reverse, get(kv, "cycleway", ""))
            bike_backward = bike_reverse[kv["cycleway"]]
        elseif haskey(bike_reverse, get(kv, "cycleway:left", ""))
            bike_backward = bike_reverse[kv["cycleway:left"]]
        elseif haskey(bike_reverse, get(kv, "cycleway:right", ""))
            bike_backward = bike_reverse[kv["cycleway:right"]]
        else
            bike_backward = false
        end
    end
    if bike_backward && haskey(oneway, get(kv, "oneway:bicycle", ""))
        oneway_bike = get(oneway, get(kv, "oneway:bicycle", ""), false)
    end

    oneway_bus_psv = get(kv, "oneway:bus", "")
    if length(oneway_bus_psv) > 0 && haskey(kv, "oneway:psv")
        oneway_bus_psv = kv["oneway:psv"]
    end
    if (get(kv, "oneway", "") == "yes" && oneway_bus_psv == "no") ||
       get(kv, "bus:backward", "") == "yes" || get(kv, "bus:backward", "") == "designated"
        bus_backward = true
    end
    if !bus_backward
        if haskey(bus_reverse, get(kv, "busway", ""))
            bus_backward = bus_reverse[get(kv, "busway", "")]
        elseif haskey(bus_reverse, get(kv, "busway:left", ""))
            bus_backward = bus_reverse[get(kv, "busway:left", "")]
        elseif haskey(bus_reverse, get(kv, "busway:right", ""))
            bus_backward = bus_reverse[get(kv, "busway:right", "")]
        elseif haskey(psv, get(kv, "lanes:psv:backward", ""))
            bus_backward = psv[get(kv, "lanes:psv:backward", "")]
        else
            bus_backward = false
        end
    end
    if bus_backward
        if haskey(oneway, oneway_bus_psv)
            oneway_bus = oneway[oneway_bus_psv]
        else
            oneway_bus = false
        end
        if !oneway_bus && get(kv, "bus:backward", "") == "yes"
            oneway_bus = true
        end
    end

    oneway_taxi_psv = get(kv, "oneway:taxi", "")
    if length(oneway_taxi_psv) > 0 && haskey(kv, "oneway:psv")
        oneway_taxi_psv = kv["oneway:psv"]
    end
    if (get(kv, "oneway", "") == "yes" && oneway_taxi_psv == "no") ||
       get(kv, "taxi:backward", "") == "yes" || get(kv, "taxi:backward", "") == "designated"
        taxi_backward = true
    end
    if !taxi_backward
        if haskey(psv, get(kv, "lanes:psv:backward", ""))
            taxi_backward = psv[get(kv, "lanes:psv:backward", "")]
        else
            taxi_backward = false
        end
    end
    if taxi_backward
        oneway_taxi = get(oneway, oneway_taxi_psv, false)

        if get(kv, "taxi:backward", "") == "yes"
            oneway_taxi = true
        end
    end

    if (get(kv, "oneway", "") == "yes" && (kv["oneway:moped"] == "no" || kv["oneway:mofa"] == "no")) ||
       get(kv, "moped:backward", "") == "yes" || get(kv, "mofa:backward", "") == "yes"
        moped_backward = true
    end
    if moped_backward
        if haskey(oneway, get(kv, "oneway:moped", ""))
            oneway_moped = oneway[get(kv, "oneway:moped", "")]
        elseif haskey(oneway, get(kv, "oneway:mofa", ""))
            oneway_moped = oneway[get(kv, "oneway:mofa", "")]
        else
            oneway_moped = false
        end
    end


    if (get(kv, "oneway", "") == "yes" && get(kv, "oneway:motorcycle", "") == "no") ||
       get(kv, "motorcycle:backward", "") == "yes"
        motorcycle_backward = true
    end
    if motorcycle_backward
        oneway_motorcycle = get(oneway, get(kv, "oneway:motorcycle", ""), false)
    end

    if (get(kv, "oneway", "") == "yes" && get(kv, "oneway:foot", "") == "no") ||
       get(kv, "foot:backward", "") == "yes"
        pedestrian_backward = true
    end
    if pedestrian_backward
        oneway_foot = get(oneway, get(kv, "oneway:foot", ""), false)
    end

    oneway_reverse = get(kv, "oneway", false)
    oneway_norm = get(oneway, get(kv, "oneway", ""), false)
    if get(kv, "junction", "") == "roundabout" || get(kv, "junction", "") == "circular"
        oneway_norm = true
        kv["roundabout"] = true
    else
        kv["roundabout"] = false
    end
    kv["oneway"] = oneway_norm
    if oneway_norm
        auto_backward = false
        truck_backward = false
        emergency_backward = false

        if bike_backward
            if oneway_bike #bike only in reverse on a bike path.
                bike_forward = false
            elseif !oneway_bike  #bike in both directions on a bike path.
                bike_forward = true
            end
        end
        if bus_backward
            if oneway_bus #bus only in reverse on a bus path.
                bus_forward = false
            elseif !oneway_bus #bus in both directions on a bus path.
                bus_forward = true
            end
        end
        if taxi_backward
            if oneway_taxi #taxi only in reverse on a taxi path.
                taxi_forward = false
            elseif !oneway_taxi #taxi in both directions on a taxi path.
                taxi_forward = true
            end
        end
        if moped_backward
            if oneway_moped #moped only in reverse direction on street
                moped_forward = false
            elseif !oneway_moped
                moped_forward = true
            end
        end
        if motorcycle_backward
            if oneway_motorcycle #motorcycle only in reverse direction on street
                motorcycle_forward = false
            elseif !oneway_motorcycle
                motorcycle_forward = true
            end
        end
        if get(kv, "highway", "") == "footway" || get(kv, "highway", "") == "pedestrian" ||
           get(kv, "highway", "") == "steps" || get(kv, "highway", "") == "path" || haskey(kv, "oneway:foot") #don't apply oneway tag unless oneway:foot || pedestrian only way
            if pedestrian_backward
                if oneway_foot #pedestrian only in reverse direction on street
                    pedestrian_forward = false
                elseif !oneway_foot
                    pedestrian_forward = true
                end
            end
        else
            pedestrian_backward = pedestrian_forward
        end
    elseif oneway_norm == false
        auto_backward = auto_forward
        truck_backward = truck_forward
        emergency_backward = emergency_forward

        if !bike_backward && get(kv, "oneway:bicycle", "") != "-1" &&
           (!haskey(kv, "oneway:bicycle") || !get(oneway, get(kv, "oneway:bicycle", ""), true) || get(kv, "oneway:bicycle", "") == "no")
            bike_backward = bike_forward
        end

        if !bus_backward && oneway_bus_psv != "-1" &&
           (length(oneway_bus_psv) > 0 || !get(oneway, oneway_bus_psv, true))
            bus_backward = bus_forward
        end

        if !taxi_backward && oneway_taxi_psv != "-1" &&
           (length(oneway_taxi_psv) > 0 || !get(oneway, oneway_taxi_psv, true))
            taxi_backward = taxi_forward
        end

        if !moped_backward &&
           (!haskey(kv, "oneway:moped") || !get(oneway, get(kv, "oneway:moped", ""), true) ||
            get(kv, "oneway:moped", "") == "no") &&
           (!haskey(kv, "oneway:mofa") || get(oneway, get(kv, "oneway:mofa", ""), true) ||
            get(kv, "oneway:mofa", "") == "no")
            moped_backward = moped_forward
        end

        if !motorcycle_backward && get(kv, "oneway:motorcycle", "") != "-1" &&
           (!haskey(kv, "oneway:motorcycle") || get(oneway, get(kv, "oneway:motorcycle", ""), true) ||
            get(kv, "oneway:motorcycle", "") == "no")
            motorcycle_backward = motorcycle_forward
        end

        if !pedestrian_backward &&
           (!haskey(kv, "oneway:foot") || get(oneway, get(kv, "oneway:foot", ""), true) ||
            get(kv, "oneway:foot", "") == "no")
            pedestrian_backward = pedestrian_forward
        end

    end

    #Bike forward / backward overrides.
    if get(shared, get(kv, "cycleway:both", ""), false) ||
       get(separated, get(kv, "cycleway:both", ""), false) ||
       get(dedicated, get(kv, "cycleway:both", ""), false) ||
       ((get(shared, get(kv, "cycleway:right", ""), false) ||
         get(separated, get(kv, "cycleway:right", ""), false) ||
         get(dedicated, get(kv, "cycleway:right", ""), false))) &&
       (get(shared, get(kv, "cycleway:left", ""), false) ||
        get(separated, get(kv, "cycleway:left", ""), false) ||
        get(dedicated, get(kv, "cycleway:left", ""), false))
        bike_forward = true
        bike_backward = true
    end

    if get(kv, "busway", "") == "lane" || (get(kv, "busway:left", "") == "lane" && get(kv, "busway:right", "") == "lane")
        bus_forward = true
        bus_backward = true
    end



    #flip the onewayness
    oneway_reverse = false
    if oneway_reverse == "-1"
        oneway_reverse = true

        forwards = auto_forward
        auto_forward = auto_backward
        auto_backward = forwards

        forwards = truck_forward
        truck_forward = truck_backward
        truck_backward = forwards

        forwards = emergency_forward
        emergency_forward = emergency_backward
        emergency_backward = forwards

        forwards = bus_forward
        bus_forward = bus_backward
        bus_backward = forwards

        forwards = taxi_forward
        taxi_forward = taxi_backward
        taxi_backward = forwards

        forwards = bike_forward
        bike_forward = bike_backward
        bike_backward = forwards

        forwards = moped_forward
        moped_forward = moped_backward
        moped_backward = forwards

        forwards = motorcycle_forward
        motorcycle_forward = motorcycle_backward
        motorcycle_backward = forwards

        forwards = pedestrian_forward
        pedestrian_forward = pedestrian_backward
        pedestrian_backward = forwards
    end

    if get(kv, "oneway:bicycle", "") == "-1"
        forwards = bike_forward
        bike_forward = bike_backward
        bike_backward = forwards
    end

    if get(kv, "oneway:moped", "") == "-1" || get(kv, "oneway:mofa", "") == "-1"
        forwards = moped_forward
        moped_forward = moped_backward
        moped_backward = forwards
    end

    if get(kv, "oneway:motorcycle", "") == "-1"
        forwards = motorcycle_forward
        motorcycle_forward = motorcycle_backward
        motorcycle_backward = forwards
    end

    if get(kv, "oneway:foot", "") == "-1"
        forwards = pedestrian_forward
        pedestrian_forward = pedestrian_backward
        pedestrian_backward = forwards
    end

    if oneway_bus_psv == "-1"
        forwards = bus_forward
        bus_forward = bus_backward
        bus_backward = forwards
    end

    # bus only logic
    if get(kv, "lanes:bus", "") == "1"
        bus_forward = true
        bus_backward = false
    elseif get(kv, "lanes:bus", "") == "2"
        bus_forward = true
        bus_backward = true
    end

    if oneway_taxi_psv == "-1"
        forwards = taxi_forward
        taxi_forward = taxi_backward
        taxi_backward = forwards
    end

    if get(kv, "lanes:psv", "") == "1"
        taxi_forward = true
        taxi_backward = false
    elseif get(kv, "lanes:psv", "") == "2"
        taxi_forward = true
        taxi_backward = true
    end

    #if none of the modes were set we arene looking at this
    if !auto_forward && !truck_forward && !bus_forward && !bike_forward &&
       !emergency_forward && !moped_forward && !motorcycle_forward &&
       !pedestrian_forward && !auto_backward && !truck_backward && !bus_backward &&
       !bike_backward && !emergency_backward && !moped_backward && !motorcycle_backward &&
       !pedestrian_backward
        if get(kv, "highway", "") != "bridleway" #save bridleways for country access logic.
            return 1
        end
    end

    #toss actual areas
    if get(kv, "area", "") == "yes"
        return 1
    end

    # # remove notes
    # for k in ["FIXME", "note", "source"]
    #     kv[k] = nothing
    # end

    #set a few flags
    rc = get(road_class, get(kv, "highway", ""), 7)
    if get(kv, "highway", "") == "construction"
        rc = get(road_class, get(kv, "construction", ""), 7)
    end

    if !haskey(kv, "highway") && ferry
        rc = 2 #TODO:  can we weight based on ferry types?
    elseif !haskey(kv, "highway") && (haskey(kv, "railway") || get(kv, "route", "") == "shuttle_train")
        rc = 2 #TODO:  can we weight based on rail types?
    end

    kv["road_class"] = rc

    kv["default_speed"] = get(default_speed, get(kv, "road_class", ""), 7)
    #lower the default speed for driveways
    if get(kv, "service", "") == "driveway"
        kv["default_speed"] = math.floor(kv["default_speed"] * 0.5)
    end

    use = get(use, get(kv, "service", ""), nothing)

    if haskey(kv, "highway")
        if get(kv, "highway", "") == "construction"
            use = 43
        elseif get(kv, "highway", "") == "track"
            use = 3
        elseif get(kv, "highway", "") == "living_street"
            use = 10
        elseif use === nothing && get(kv, "highway", "") == "service"
            use = 11
        elseif get(kv, "highway", "") == "cycleway"
            use = 20
        elseif !pedestrian_forward && !auto_forward && !auto_backward && (bike_forward || bike_backward)
            use = 20
        elseif (get(kv, "highway", "") == "footway" && get(kv, "footway", "") == "sidewalk")
            use = 24
        elseif (get(kv, "highway", "") == "footway" && get(kv, "footway", "") == "crossing")
            use = 32
        elseif get(kv, "highway", "") == "footway"
            use = 25
        elseif get(kv, "highway", "") == "elevator"
            use = 33 #elevator
        elseif (get(kv, "highway", "") == "steps" && haskey(kv, "conveying"))
            use = 34 #escalator
        elseif get(kv, "highway", "") == "steps"
            use = 26 #steps/stairs
        elseif get(kv, "highway", "") == "path"
            use = 27
        elseif get(kv, "highway", "") == "pedestrian"
            use = 28
        elseif pedestrian_forward && !auto_forward && !auto_backward && !truck_forward &&
               !truck_backward && !bus_forward && !bus_backward && !bike_forward &&
               !bike_backward && !moped_forward && !moped_backward && !motorcycle_forward &&
               !motorcycle_backward
            use = 28
        elseif get(kv, "highway", "") == "bridleway"
            use = 29
        end
    end

    if use === nothing && haskey(kv, "service")
        use = 40 #other
    elseif use === nothing
        use = 0 #general road, no special use
    end

    # not override 'construction' use
    if use != 43 && (get(kv, "access", "") == "emergency" || get(kv, "emergency", "") == "yes") &&
       !auto_forward && !auto_backward && !truck_forward && !truck_backward &&
       !bus_forward && !bus_backward && !bike_forward && !bike_backward &&
       !moped_forward && !moped_backward && !motorcycle_forward && !motorcycle_backward
        use = 7
    end

    kv["use"] = use

    if haskey(shoulder, get(kv, "shoulder", ""))
        r_shoulder = shoulder[get(kv, "shoulder", "")]
    elseif haskey(shoulder, get(kv, "shoulder:both", ""))
        r_shoulder = shoulder[get(kv, "shoulder:both", "")]
    else
        r_shoulder = nothing
    end
    l_shoulder = r_shoulder

    if r_shoulder === nothing
        if haskey(shoulder, get(kv, "shoulder:right", ""))
            r_shoulder = shoulder[kv["shoulder:right"]]
        else
            r_shoulder = get(shoulder_right, get(kv, "shoulder", ""), false)
        end
        if haskey(shoulder, get(kv, "shoulder:left", ""))
            l_shoulder = shoulder[get(kv, "shoulder:left", "")]
        else
            l_shoulder = get(shoulder_left, get(kv, "shoulder", ""), false)
        end

        #If the road is oneway && one shoulder is tagged but not the other, we set both to true so that when setting the
        #shoulder in graphbuilder, driving on the right side vs the left sideesn't cause the edge to miss the shoulder tag
        if oneway_norm && r_shoulder && !l_shoulder
            l_shoulder = true
        elseif oneway_norm && !r_shoulder && l_shoulder
            r_shoulder = true
        end
    end

    kv["shoulder_right"] = r_shoulder
    kv["shoulder_left"] = l_shoulder


    cycle_lane_right_opposite = false
    cycle_lane_left_opposite = false

    cycle_lane_right = 0
    cycle_lane_left = 0

    #We have special use cases for cycle lanes when on a cycleway, footway, || path
    if (use == 20 || use == 25 || use == 27) && (bike_forward || bike_backward)
        if !pedestrian_forward
            cycle_lane_right = 3 #separated
        elseif get(kv, "segregated", "") == "yes"
            cycle_lane_right = 2 #dedicated
        elseif get(kv, "segregated", "") == "no"
            cycle_lane_right = 1 #shared
        elseif use == 20
            cycle_lane_right = 2 #If no segregated tag but it is tagged as a cycleway we assume separated lanes
        else
            cycle_lane_right = 1 #If no segregated tag && it's tagged as a footway || path we assume shared lanes
        end
        cycle_lane_left = cycle_lane_right
    else
        #Set flags if any of the lanes are marked "opposite" (contraflow)
        cycle_lane_right_opposite = get(bike_reverse, get(kv, "cycleway", ""), false)
        cycle_lane_left_opposite = cycle_lane_right_opposite

        if cycle_lane_right_opposite == false
            cycle_lane_right_opposite = get(bike_reverse, get(kv, "cycleway:right", ""), false)
            cycle_lane_left_opposite = get(bike_reverse, get(kv, "cycleway:left", ""), false)
        end

        #Figure out which side of the road has what cyclelane
        if haskey(shared, get(kv, "cycleway", ""))
            cycle_lane_right = shared[get(kv, "cycleway", "")]
        elseif haskey(separated, get(kv, "cycleway", ""))
            cycle_lane_right = separated[get(kv, "cycleway", "")]
        elseif haskey(dedicated, get(kv, "cycleway", ""))
            cycle_lane_right = dedicated[get(kv, "cycleway", "")]
        else
            cycle_lane_right = get(buffer, get(kv, "cycleway:both:buffer", ""), 0)
        end
        cycle_lane_left = cycle_lane_right

        if cycle_lane_right == 0
            if haskey(shared, get(kv, "cycleway:right", ""))
                cycle_lane_right = shared[get(kv, "cycleway:right", "")]
            elseif haskey(separated, get(kv, "cycleway:right", ""))
                cycle_lane_right = separated[get(kv, "cycleway:right", "")]
            elseif haskey(dedicated, get(kv, "cycleway:right", ""))
                cycle_lane_right = dedicated[get(kv, "cycleway:right", "")]
            else
                cycle_lane_right = get(buffer, get(kv, "cycleway:right:buffer", ""), 0)
            end
            if haskey(shared, get(kv, "cycleway:left", ""))
                cycle_lane_left = shared[get(kv, "cycleway:left", "")]
            elseif haskey(separated, get(kv, "cycleway:left", ""))
                cycle_lane_left = separated[get(kv, "cycleway:left", "")]
            elseif haskey(dedicated, get(kv, "cycleway:left", ""))
                cycle_lane_left = dedicated[get(kv, "cycleway:left", "")]
            else
                cycle_lane_left = get(buffer, get(kv, "cycleway:left:buffer", ""), 0)
            end
        end

        #If we have the oneway:bicycle=no tag && there are not "opposite_lane/opposite_track" tags there are certain situations where
        #the cyclelane is considered a two-way. (Based off of some examples on wiki.openstreetmap.org/wiki/Bicycle)
        if get(kv, "oneway:bicycle", "") == "no" && !cycle_lane_right_opposite && !cycle_lane_left_opposite
            if cycle_lane_right == 2 || cycle_lane_right == 3
                #Example M1 || M2d but on the right side
                if oneway_norm
                    cycle_lane_left = cycle_lane_right
                    cycle_lane_left_opposite = true

                    #Example L1b
                elseif cycle_lane_left == 0
                    cycle_lane_left = cycle_lane_right
                end

            elseif cycle_lane_left == 2 || cycle_lane_left == 3
                #Example M2d
                if oneway_norm
                    cycle_lane_right = cycle_lane_left
                    cycle_lane_right_opposite = true

                    #Example L1b but on the left side
                elseif cycle_lane_right == 0
                    cycle_lane_right = cycle_lane_left
                end
            end
        end
    end

    kv["cycle_lane_right"] = cycle_lane_right
    kv["cycle_lane_left"] = cycle_lane_left

    kv["cycle_lane_right_opposite"] = cycle_lane_right_opposite
    kv["cycle_lane_left_opposite"] = cycle_lane_left_opposite


    highway_type = get(kv, "highway", "")
    if get(kv, "highway", "") == "construction"
        highway_type = kv["construction"]
    end
    if highway_type && string.find(highway_type, "_link") #*_link
        kv["link"] = true  #do we need to add more?  turnlane?
        kv["link_type"] = kv["link_type"]                                                                             #!!!
    end

    if haskey(private, get(kv, "access", ""))
        kv["private"] = private[get(kv, "access", "")]
    else
        kv["private"] = get(private, get(kv, "motor_vehicle", ""), false)
    end
    kv["no_thru_traffic"] = get(no_thru_traffic, get(kv, "access", ""), false)
    kv["ferry"] = ferry
    kv["rail"] = auto_forward && (get(kv, "railway", "") == "rail" || get(kv, "route", "") == "shuttle_train")
    kv["name"] = kv["name"]
    kv["name:en"] = kv["name:en"]
    kv["alt_name"] = kv["alt_name"]
    kv["official_name"] = kv["official_name"]

    maxspeed = parse_maxspeed(get(kv, "maxspeed", nothing))
    maxspeed_hgv = parse_maxspeed(get(kv, "maxspeed:hgv", nothing))

    advisory_speed = parse_maxspeed(get(kv, "maxspeed:advisory", nothing))
    average_speed = parse_maxspeed(get(kv, "maxspeed:practical", nothing))
    backward_speed = parse_maxspeed(get(kv, "maxspeed:backward", nothing))
    forward_speed = parse_maxspeed(get(kv, "maxspeed:forward", nothing))


    kv["int"] = kv["int"]
    kv["int_ref"] = kv["int_ref"]
    kv["surface"] = kv["surface"]
    kv["wheelchair"] = get(wheelchair, get(kv, "wheelchair", ""), false)

    #lower the default speed for tracks
    if get(kv, "highway", "") == "track"
        kv["default_speed"] = 5
        if length(get(kv, "tracktype", "")) > 0
            if get(kv, "tracktype", "") == "grade1"
                kv["default_speed"] = 20
            elseif get(kv, "tracktype", "") == "grade2"
                kv["default_speed"] = 15
            elseif get(kv, "tracktype", "") == "grade3"
                kv["default_speed"] = 12
            elseif get(kv, "tracktype", "") == "grade4"
                kv["default_speed"] = 10
            end
        end
    end

    #use unsigned_ref if all the conditions are met.
    if (!haskey(kv, "name") && !haskey(kv, "name:en") && !haskey(kv, "alt_name") && !haskey(kv, "official_name") &&
        !haskey(kv, "ref") && !haskey(kv, "int_ref")) &&
       (get(kv, "highway", "") == "motorway" || get(kv, "highway", "") == "trunk" ||
        get(kv, "highway", "") == "primary") &&
       haskey(kv, "unsigned_ref")
        kv["ref"] = kv["unsigned_ref"]
    end

    lane_count = lanecount(get(kv, "lanes", nothing))
    forward_lanes = lanecount(get(kv, "lanes:forward", nothing))
    backward_lanes = lanecount(get(kv, "lanes:backward", nothing))


    bridge = get(bridge, get(kv, "bridge", ""), false)

    # TODO access:conditional
    if get(kv, "seasonal", "") && get(kv, "seasonal", "") != "no"
        kv["seasonal"] = true
    end

    kv["hov_tag"] = true
    if (get(kv, "hov", "") && get(kv, "hov", "") == "no")
        hov_forward = false
        hov_backward = false
    else
        hov_forward = auto_forward
        hov_backward = auto_backward
    end

    # hov restrictions
    if (haskey(kv, "hov") && get(kv, "hov", "") != "no") ||
       haskey(kv, "hov:lanes") || haskey(kv, "hov:minimum")
        only_hov_allowed = get(kv, "hov", "") == "designated"
        # If "hov:lanes" is specified ensure all lanes are tagged "designated"
        if only_hov_allowed
            if haskey(kv, "hov:lanes")
                for lane in split(get(kv, "hov:lanes", ""), "|")
                    if lane && lane != "designated"
                        only_hov_allowed = false
                    end
                end
            end
        end
        # I want to be strict with the "hov:minimum" tag: I will only accept the
        # values 2 or 3. We want to be strict because routing onto an HOV lane
        # without the correct number of occupants is illegal.
        if only_hov_allowed
            if get(kv, "hov:minimum", "") == "2"
                kv["hov_type"] = "HOV2"
            elseif get(kv, "hov:minimum", "") == "3"
                kv["hov_type"] = "HOV3"
            else
                only_hov_allowed = false
            end
        end
        # HOV lanes are sometimes time-conditional && can change direction. We avoid
        # these. Also, we expect "hov_type" to be set.
        if only_hov_allowed
            avoid_these_hovs = get(kv, "oneway", "") == "alternating" || get(kv, "oneway", "") == "reversible" ||
                               get(kv, "oneway", "") == "false" || haskey(kv, "oneway:conditional") ||
                               haskey(kv, "access:conditional")
            only_hov_allowed = !avoid_these_hovs
        end
        if only_hov_allowed
            # If we get here we know the way is a true hov-only-lane (not mixed).
            # As a result, none of the following costings can use it.
            # (Okay, that's not exactly true, we some wizardry in some of the
            # costings to allow hov under certain conditions.)
            if !auto_tag
                auto_forward = false
                auto_backward = false
            end
            if !truck_tag
                truck_forward = false
                truck_backward = false
            end
            if !pedestrian_tag
                pedestrian_forward = false
                pedestrian_backward = false
            end
            if !bike_tag
                bike_forward = false
                bike_backward = false
            end
        else
            # This is not an hov-only lane.
            hov_forward = false
            hov_backward = false
        end
    end

    tunnel = get(tunnel, get(kv, "tunnel", ""), false)
    toll = get(toll, get(kv, "toll", ""), false)
    # kv["destination"] = kv["destination"]
    # kv["destination:forward"] = kv["destination:forward"]
    # kv["destination:backward"] = kv["destination:backward"]
    # kv["destination:ref"] = kv["destination:ref"]
    # kv["destination:ref:to"] = kv["destination:ref:to"]
    # kv["destination:street"] = kv["destination:street"]
    # kv["destination:street:to"] = kv["destination:street:to"]
    # kv["junction:ref"] = kv["junction:ref"]
    # kv["turn:lanes"] = kv["turn:lanes"]
    # kv["turn:lanes:forward"] = kv["turn:lanes:forward"]
    # kv["turn:lanes:backward"] = kv["turn:lanes:backward"]
    #truck goodies
    if haskey(kv, "maxheight")
        maxheight = parse_dimension(get(kv, "maxheight", nothing))
    else
        maxheight = parse_dimension(get(kv, "maxheight:physical", nothing))
    end
    if haskey(kv, "maxwidth")
        maxwidth = parse_dimension(get(kv, "maxwidth", nothing))
    else
        maxwidth = parse_dimension(get(kv, "maxwidth:physical", nothing))
    end
    maxlength = parse_dimension(get(kv, "maxlength", nothing))

    maxweight = parse_weight(get(kv, "maxweight", nothing))
    maxaxleload = parse_weight(get(kv, "maxaxleload", nothing))

    #TODO: hazmat really should have subcategories
    hazmat = 0
    if haskey(hazmat, get(kv, "hazmat", ""))
        hazmat += 1
    elseif hazmat[kv["hazmat:water"]]
        hazmat += 2
    elseif hazmat[kv["hazmat:A"]]
        hazmat += 4
    elseif hazmat[kv["hazmat:B"]]
        hazmat += 8
    elseif hazmat[kv["hazmat:C"]]
        hazmat += 16
    elseif hazmat[kv["hazmat:D"]]
        hazmat += 32
    elseif hazmat[kv["hazmat:E"]]
        hazmat += 64
    end

    if haskey(kv, "hgv:national_network") || haskey(kv, "hgv:state_network") || get(kv, "hgv", "") == "local" ||
       get(kv, "hgv", "") == "designated"
        truck_route = true
    end

    nref = get(kv, "ncn_ref", nothing)
    rref = get(kv, "rcn_ref", nothing)
    lref = get(kv, "lcn_ref", nothing)
    bike_mask = 0
    if length(nref) > 0 || get(kv, "ncn", "") == "yes"
        bike_mask = 1
    end
    if length(rref) > 0 || get(kv, "rcn", "") == "yes"
        bike_mask = bit.bor(bike_mask, 2)
    end
    if length(lref) > 0 || get(kv, "lcn", "") == "yes"
        bike_mask = bit.bor(bike_mask, 4)
    end
    if get(kv, "mtb", "") == "yes"
        bike_mask = bit.bor(bike_mask, 8)
    end

    # kv["bike_national_ref"] = nref
    # kv["bike_regional_ref"] = rref
    # kv["bike_local_ref"] = lref
    # kv["bike_network_mask"] = bike_mask

    # # turn semicolon into colon due to challenges to store ";" in string
    # if haskey(kv, "level")
    #     kv["level"] = kv["level"]:gsub(";", "")
    # end

    return 0
end
