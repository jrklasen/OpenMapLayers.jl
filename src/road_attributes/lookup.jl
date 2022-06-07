
highway = Dict{String,Dict}(
    "motorway" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => false, "motorcycle_forward" => true, "pedestrian_forward" => false, "bike_forward" => false),
    "motorway_link" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => false, "motorcycle_forward" => true, "pedestrian_forward" => false, "bike_forward" => false),
    "trunk" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "trunk_link" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "primary" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "primary_link" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "secondary" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "secondary_link" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "residential" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "residential_link" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "service" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "tertiary" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "tertiary_link" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "road" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "track" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "unclassified" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "undefined" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => false, "bike_forward" => false),
    "unknown" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => false, "bike_forward" => false),
    "living_street" => Dict{String,Bool}("auto_forward" => true, "truck_forward" => true, "bus_forward" => true, "taxi_forward" => true, "moped_forward" => true, "motorcycle_forward" => true, "pedestrian_forward" => true, "bike_forward" => true),
    "footway" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => true, "bike_forward" => false),
    "pedestrian" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => true, "bike_forward" => false),
    "steps" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => true, "bike_forward" => true),
    "bridleway" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => false, "bike_forward" => false),
    "cycleway" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => false, "bike_forward" => true),
    "path" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => true, "bike_forward" => true),
    "bus_guideway" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => true, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => false, "bike_forward" => false),
    "busway" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => true, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => false, "bike_forward" => false),
    "corridor" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => true, "bike_forward" => false),
    "elevator" => Dict{String,Bool}("auto_forward" => false, "truck_forward" => false, "bus_forward" => false, "taxi_forward" => false, "moped_forward" => false, "motorcycle_forward" => false, "pedestrian_forward" => true, "bike_forward" => false)
)

road_class = Dict{String,Int}(
    "motorway" => 0,
    "motorway_link" => 0,
    "trunk" => 1,
    "trunk_link" => 1,
    "primary" => 2,
    "primary_link" => 2,
    "secondary" => 3,
    "secondary_link" => 3,
    "tertiary" => 4,
    "tertiary_link" => 4,
    "unclassified" => 5,
    "residential" => 6,
    "residential_link" => 6
)

restriction = Dict{String,Int}(
    "no_left_turn" => 0,
    "no_right_turn" => 1,
    "no_straight_on" => 2,
    "no_u_turn" => 3,
    "only_right_turn" => 4,
    "only_left_turn" => 5,
    "only_straight_on" => 6,
    "no_entry" => 7,
    "no_exit" => 8,
    "no_turn" => 9
)

#the default speed for tracks is lowered after
#the call to default_speed
default_speed = Dict{String,Int}(
    "0" => 105,
    "1" => 90,
    "2" => 75,
    "3" => 60,
    "4" => 50,
    "5" => 40,
    "6" => 35,
    "7" => 25
)

access = Dict{String,Bool}(
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

private = Dict{String,Bool}(
    "private" => true,
    "destination" => true,
    "customers" => true,
    "delivery" => true,
    "permit" => true,
    "residents" => true
)

no_thru_traffic = Dict{String,Bool}(
    "destination" => true,
    "customers" => true,
    "delivery" => true,
    "permit" => true,
    "residents" => true
)

sidewalk = Dict{String,Bool}(
    "both" => true,
    "none" => false,
    "no" => false,
    "right" => true,
    "left" => true,
    "separate" => false,
    "yes" => true,
    "shared" => true,
    "this" => true,
    "detached" => false,
    "raised" => true,
    "separate_double" => false,
    "sidepath" => false,
    "explicit" => true
)

use = Dict{String,Int}(
    "driveway" => 4,
    "alley" => 5,
    "parking_aisle" => 6,
    "emergency_access" => 7,
    "drive-through" => 8
)

motor_vehicle = Dict{String,Bool}(
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

moped = Dict{String,Bool}(
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

foot = Dict{String,Bool}(
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

wheelchair = Dict{String,Bool}(
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

bus = Dict{String,Bool}(
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

taxi = Dict{String,Bool}(
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

psv = Dict{String,Bool}(
    "bus" => true,
    "taxi" => true,
    "no" => false,
    "yes" => true,
    "designated" => true,
    "permissive" => true,
    "1" => true,
    "2" => true
)

truck = Dict{String,Bool}(
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

hazmat = Dict{String,Bool}(
    "designated" => true,
    "yes" => true,
    "no" => false,
    "destination" => true,
    "delivery" => true
)

shoulder = Dict{String,Bool}(
    "yes" => true,
    "both" => true,
    "no" => false
)

shoulder_right = Dict{String,Bool}(
    "right" => true
)

shoulder_left = Dict{String,Bool}(
    "left" => true
)

bicycle = Dict{String,Bool}(
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

cycleway = Dict{String,Bool}(
    "yes" => true,
    "designated" => true,
    "use_sidepath" => true,
    "permissive" => true,
    "destination" => true,
    "dismount" => true,
    "lane" => true,
    "track" => true,
    "shared" => true,
    "shared_lane" => true,
    "sidepath" => true,
    "share_busway" => true,
    "allowed" => true,
    "private" => true,
    "cyclestreet" => true,
    "crossing" => true
)

bike_reverse = Dict{String,Bool}(
    "opposite" => true,
    "opposite_lane" => true,
    "opposite_track" => true
)

bus_reverse = Dict{String,Bool}(
    "opposite" => true,
    "opposite_lane" => true
)

shared = Dict{String,Int}(
    "shared_lane" => 1,
    "share_busway" => 1,
    "shared" => 1
)

buffer = Dict{String,Int}(
    "yes" => 2
)

dedicated = Dict{String,Int}(
    "opposite_lane" => 2,
    "lane" => 2,
    "buffered_lane" => 2
)

separated = Dict{String,Int}(
    "opposite_track" => 3,
    "track" => 3
)

oneway = Dict{String,Int}(
    "no" => false,
    "false" => false,
    "-1" => true,
    "yes" => true,
    "true" => true,
    "1" => true,
    "reversible" => false,
    "alternating" => false
)

bridge = Dict{String,Bool}(
    "yes" => true,
    "no" => false,
    "1" => true
)

#TODO: building_passage is for ped only
tunnel = Dict{String,Bool}(
    "yes" => true,
    "no" => false,
    "1" => true,
    "building_passage" => true
)

#TODO: snowmobile might not really be passable for much other than ped..
toll = Dict{String,Bool}(
    "yes" => true,
    "no" => false,
    "true" => true,
    "false" => false,
    "1" => true,
    "interval" => true,
    "snowmobile" => true
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
