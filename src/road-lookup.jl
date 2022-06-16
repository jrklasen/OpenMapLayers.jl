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

PRIVAT_ACCESS = Dict{String,Bool}(
    "private" => true,
    "destination" => true,
    "customers" => true,
    "delivery" => true,
    "permit" => true,
    "residents" => true
)

ROAD_CLASS = Dict{String,Symbol}(
    "motorway" => :motorway,
    "motorway_link" => :motorway_link,
    "trunk" => :trunk,
    "trunk_link" => :trunk_link,
    "primary" => :primary,
    "primary_link" => :primary_link,
    "secondary" => :secondary,
    "secondary_link" => :secondary_link,
    "tertiary" => :tertiary,
    "tertiary_link" => :tertiary_link,
    "unclassified" => :unclassified,
    "residential" => :residential,
    "residential_link" => :residential_link,
)

ONEWAY_ACCESS = Dict{String,Bool}(
    "no" => false,
    "false" => false,
    "-1" => true,
    "yes" => true,
    "true" => true,
    "1" => true,
    "reversible" => false,
    "alternating" => false,
)

ONEWAY_DIRECTION = Dict{String,Symbol}(
    "no" => :both,
    "false" => :both,
    "-1" => :backward,
    "yes" => :forward,
    "true" => :forward,
    "1" => :forward,
    "reversible" => :reversible,
    "alternating" => :reversible,
)

BRIDGE = Dict{String,Bool}(
    "yes" => true,
    "no" => false,
    "1" => true,
)

TUNNEL = Dict{String,Bool}(
    "yes" => true,
    "no" => false,
    "1" => true,
    "building_passage" => true,
)


TURN_LANES = Dict{String,Symbol}(
    "none" => :none,
    "" => :none,
    "left" => :left,
    "slight_left" => :slight_left,
    "sharp_left" => :sharp_left,
    "through" => :through,
    "right" => :right,
    "slight_right" => :slight_right,
    "sharp_right" => :sharp_right,
    "reverse" => :u_turn,
    "merge_to_left" => :merge_to_left,
    "merge_to_right" => :merge_to_right,
)

SHOULDER = Dict{String,Bool}(
    "yes" => true,
    "both" => true,
    "no" => false,
)

SHOULDER_RIGHT = Dict{String,Bool}(
    "right" => true,
)

SHOULDER_LEFT = Dict{String,Bool}(
    "left" => true,
)

TOLL = Dict{String,Bool}(
    "yes" => true,
    "no" => false,
    "true" => true,
    "false" => false,
    "1" => true,
    "interval" => true,
    "snowmobile" => true,
)

RESTRICTION = Dict{String,Symbol}(
    "no_left_turn" => :no_left_turn,
    "no_right_turn" => :no_right_turn,
    "no_straight_on" => :no_straight_on,
    "no_u_turn" => :no_u_turn,
    "only_right_turn" => :only_right_turn,
    "only_left_turn" => :only_left_turn,
    "only_straight_on" => :only_straight_on,
    "no_entry" => :no_entry,
    "no_exit" => :no_exit,
    "no_turn" => :no_turn,
)

# pedestrian specific
FOOT_ACCESS = Dict{String,Bool}(
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

HIGHWAY_FOOT_ACCESS = Dict{String,Bool}(
    "motorway" => false,
    "motorway_link" => false,
    "trunk" => true,
    "trunk_link" => true,
    "primary" => true,
    "primary_link" => true,
    "secondary" => true,
    "secondary_link" => true,
    "residential" => true,
    "residential_link" => true,
    "service" => true,
    "tertiary" => true,
    "tertiary_link" => true,
    "road" => true,
    "track" => true,
    "unclassified" => true,
    "undefined" => false,
    "unknown" => false,
    "living_street" => true,
    "footway" => true,
    "pedestrian" => true,
    "steps" => true,
    "bridleway" => false,
    "cycleway" => false,
    "path" => true,
    "bus_guideway" => false,
    "busway" => false,
    "corridor" => true,
    "elevator" => true,
)

# wheelchair specific
WHEELCHAIR_ACCESS = Dict{String,Bool}(
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

# bicycle specific
BICYCLE_ACCESS = Dict{String,Bool}(
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

HIGHWAY_BICYCLE_ACCESS = Dict{String,Bool}(
    "motorway" => false,
    "motorway_link" => false,
    "trunk" => true,
    "trunk_link" => true,
    "primary" => true,
    "primary_link" => true,
    "secondary" => true,
    "secondary_link" => true,
    "residential" => true,
    "residential_link" => true,
    "service" => true,
    "tertiary" => true,
    "tertiary_link" => true,
    "road" => true,
    "track" => true,
    "unclassified" => true,
    "undefined" => false,
    "unknown" => false,
    "living_street" => true,
    "footway" => false,
    "pedestrian" => false,
    "steps" => true,
    "bridleway" => false,
    "cycleway" => true,
    "path" => true,
    "bus_guideway" => false,
    "busway" => false,
    "corridor" => false,
    "elevator" => false,
)

BICYCLE_DEDICATED = Dict{String,Symbol}(
    "opposite_lane" => :dedicated,
    "lane" => :dedicated,
    "buffered_lane" => :dedicated,
)

BICYCLE_SEPARATED = Dict{String,Symbol}(
    "opposite_track" => :separated,
    "track" => :separated,
)

BICYCLE_BUFFER = Dict{String,Symbol}(
    "yes" => :dedicated,
)

BICYCLE_SHARED = Dict{String,Symbol}(
    "shared_lane" => :shared,
    "share_busway" => :shared,
    "shared" => :shared,
)

BICYCLE_REVERSE = Dict{String,Bool}(
    "opposite" => true,
    "opposite_lane" => true,
    "opposite_track" => true,
)

CYCLEWAY = Dict{String,Bool}(
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
    "crossing" => true,
)

# moped specific
MOPED_ACCESS = Dict{String,Bool}(
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

HIGHWAY_MOPED_ACCESS = Dict{String,Bool}(
    "motorway" => false,
    "motorway_link" => false,
    "trunk" => true,
    "trunk_link" => true,
    "primary" => true,
    "primary_link" => true,
    "secondary" => true,
    "secondary_link" => true,
    "residential" => true,
    "residential_link" => true,
    "service" => true,
    "tertiary" => true,
    "tertiary_link" => true,
    "road" => true,
    "track" => true,
    "unclassified" => true,
    "undefined" => false,
    "unknown" => false,
    "living_street" => true,
    "footway" => false,
    "pedestrian" => false,
    "steps" => false,
    "bridleway" => false,
    "cycleway" => false,
    "path" => false,
    "bus_guideway" => false,
    "busway" => false,
    "corridor" => false,
    "elevator" => false,
)

# motorcycle specific
MOTORCYCLE_ACCESS = Dict{String,Bool}(
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

HIGHWAY_MOTORCYCLE_ACCESS = Dict{String,Bool}(
    "motorway" => true,
    "motorway_link" => true,
    "trunk" => true,
    "trunk_link" => true,
    "primary" => true,
    "primary_link" => true,
    "secondary" => true,
    "secondary_link" => true,
    "residential" => true,
    "residential_link" => true,
    "service" => true,
    "tertiary" => true,
    "tertiary_link" => true,
    "road" => true,
    "track" => true,
    "unclassified" => true,
    "undefined" => false,
    "unknown" => false,
    "living_street" => true,
    "footway" => false,
    "pedestrian" => false,
    "steps" => false,
    "bridleway" => false,
    "cycleway" => false,
    "path" => false,
    "bus_guideway" => false,
    "busway" => false,
    "corridor" => false,
    "elevator" => false,
)

# car specific
MOTOR_VEHICLE_ACCESS = Dict{String,Bool}(
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

HIGHWAY_CAR_ACCESS = Dict{String,Bool}(
    "motorway" => true,
    "motorway_link" => true,
    "trunk" => true,
    "trunk_link" => true,
    "primary" => true,
    "primary_link" => true,
    "secondary" => true,
    "secondary_link" => true,
    "residential" => true,
    "residential_link" => true,
    "service" => true,
    "tertiary" => true,
    "tertiary_link" => true,
    "road" => true,
    "track" => true,
    "unclassified" => true,
    "undefined" => false,
    "unknown" => false,
    "living_street" => true,
    "footway" => false,
    "pedestrian" => false,
    "steps" => false,
    "bridleway" => false,
    "cycleway" => false,
    "path" => false,
    "bus_guideway" => false,
    "busway" => false,
    "corridor" => false,
    "elevator" => false,
)

# taxi specific
TAXI_ACCESS = Dict{String,Bool}(
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

HIGHWAY_TAXI_ACCESS = Dict{String,Bool}(
    "motorway" => true,
    "motorway_link" => true,
    "trunk" => true,
    "trunk_link" => true,
    "primary" => true,
    "primary_link" => true,
    "secondary" => true,
    "secondary_link" => true,
    "residential" => true,
    "residential_link" => true,
    "service" => true,
    "tertiary" => true,
    "tertiary_link" => true,
    "road" => true,
    "track" => true,
    "unclassified" => true,
    "undefined" => false,
    "unknown" => false,
    "living_street" => true,
    "footway" => false,
    "pedestrian" => false,
    "steps" => false,
    "bridleway" => false,
    "cycleway" => false,
    "path" => false,
    "bus_guideway" => false,
    "busway" => false,
    "corridor" => false,
    "elevator" => false,
)

# taxi and bus specific
PSV_ACCESS = Dict{String,Bool}(
    "bus" => true,
    "no" => false,
    "yes" => true,
    "designated" => true,
    "permissive" => true,
    "true" => true,
    "true" => true
)

# bus specific
BUS_ACCESS = Dict{String,Bool}(
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

HIGHWAY_BUS_ACCESS = Dict{String,Bool}(
    "motorway" => true,
    "motorway_link" => true,
    "trunk" => true,
    "trunk_link" => true,
    "primary" => true,
    "primary_link" => true,
    "secondary" => true,
    "secondary_link" => true,
    "residential" => true,
    "residential_link" => true,
    "service" => true,
    "tertiary" => true,
    "tertiary_link" => true,
    "road" => true,
    "track" => true,
    "unclassified" => true,
    "undefined" => false,
    "unknown" => false,
    "living_street" => true,
    "footway" => false,
    "pedestrian" => false,
    "steps" => false,
    "bridleway" => false,
    "cycleway" => false,
    "path" => false,
    "bus_guideway" => true,
    "busway" => true,
    "corridor" => false,
    "elevator" => false,
)

# truck specific
TRUCK_ACCESS = Dict{String,Bool}(
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

HIGHWAY_TRUCK_ACCESS = Dict{String,Bool}(
    "motorway" => true,
    "motorway_link" => true,
    "trunk" => true,
    "trunk_link" => true,
    "primary" => true,
    "primary_link" => true,
    "secondary" => true,
    "secondary_link" => true,
    "residential" => true,
    "residential_link" => true,
    "service" => true,
    "tertiary" => true,
    "tertiary_link" => true,
    "road" => true,
    "track" => true,
    "unclassified" => true,
    "undefined" => false,
    "unknown" => false,
    "living_street" => true,
    "footway" => false,
    "pedestrian" => false,
    "steps" => false,
    "bridleway" => false,
    "cycleway" => false,
    "path" => false,
    "bus_guideway" => false,
    "busway" => false,
    "corridor" => false,
    "elevator" => false,
)
