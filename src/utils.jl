"""
Parse maxspeed tag as number
"""
function parse_maxspeed(tag::Union{String,Nothing})::Union{Float64,Missing,Nothing}
    if tag === nothing
        return nothing
    end
    if tag === "none"
        return Inf64
    end
    # turn commas into dots to handle European-style decimal separators
    tag = replace(tag, "," => ".")
    number = match(r"[+-]?((\d+\.?\d*)|(\.\d+))", tag)
    if number !== nothing
        number = parse(Float64, number.match)
        unit = match(r"(km/h|kmh|kph|mph|knots)$", tag)
        if unit === nothing && unit.match === nothing
            return round(number, digits=2)
        elseif unit.match in ["km/h", "kmh", "kph"]
            return round(number, digits=2)
        elseif unit.match == "mph"
            return round(number * 1.609, digits=2)
        elseif unit.match == "knots"
            return round(number * 1.852, digits=2)
        end
    end
    return missing
end


"""
Parsing height, width and length tags as a number
"""
function parse_dimension(tag::Union{String,Nothing})::Union{Real,Missing,Nothing}
    if tag === nothing
        return nothing
    end
    # turn commas into dots to handle European-style decimal separators
    tag = replace(tag, "," => ".")
    number = match(r"[+-]?((\d+\.?\d*)|(\.\d+))", tag)
    if number !== nothing
        number = parse(Float64, number.match)
        unit = match(r"(m|meter|meters|cm|ft|feet|foot|in|inch|inches)$", tag)
        if unit === nothing && unit.match === nothing
            return round(number, 2)
        elseif unit.match in ["m", "meter", "meters"]
            return round(number, 2)
        elseif unit.match == "cm"
            return round(number * 0.01, 2)
        elseif unit.match in ["ft", "feet", "foot"]
            return round(number * 0.3048, 2)
        elseif unit.match in ["in", "inch", "inches"]
            return round(number * 0.0254, 2)
        end
    end
    return missing
end


"""
Parsing weight tags as a number
"""
function parse_weight(tag::Union{String,Nothing})::Union{Real,Missing,Nothing}
    if tag === nothing
        return nothing
    end
    # turn commas into dots to handle European-style decimal separators
    tag = replace(tag, "," => ".")
    number = match(r"[+-]?((\d+\.?\d*)|(\.\d+))", tag)
    if number !== nothing
        number = parse(Float64, number.match)
        unit = match(r"(t|tonne|tonnes|kg|lb|lbs)$", tag)
        if unit === nothing && unit.match === nothing
            return round(number, 2)
        elseif unit.match in ["t", "tonne", "tonnes"]
            return round(number, 2)
        elseif unit.match == "kg"
            return round(number * 0.001, 2)
        elseif unit.match in ["lb", "lbs"]
            return round(number * 0.0005, 2)
        end
    end
    return missing
end


"""
Parse lane count as as number
"""
function parse_lane_count(tag::Union{String,Nothing})::Union{Int8,Missing,Nothing}
    if tag === nothing
        return nothing
    end
    number = match(r"[+-]?((\d+\.?\d*)|(\.\d+))", tag)
    if number !== nothing
        lanes = Int8(floor(parse(Float64, number.match)))
        if lanes > 15
            return missing
        end
        return lanes
    end
    return missing
end

"""
Parse turn lane as symbolds
"""
function parse_turn_lanes(tag::Union{String,Nothing})::Union{Vector{Vector{Union{Symbol,Missing}}},Nothing}
    if tag === nothing
        return nothing
    end
    # split by '|' into single lanes
    # split by ';' into multiple instructions per lane
    split_lanes = split.(split(tag, '|'), ';')
    # validate against lookup
    lane_turns = [[get(TURN_LANES, i, missing) for i in j]  for j in split_lanes]
    return lane_turns
end

"""
Tokenize conditional tags. The conditions get not parsed as this needs domain knowledge for the specific condition,
instead they simply split in a defined ordered structure of tokens
"""
function tokenize_conditional(tag::Union{String,Nothing})::Vector{Dict}
    if tag === nothing || findfirst(isequal('@'), tag) === nothing
        return nothing
    end
    # split by ";" which are not within parentheses, these are spread conditions
    # split by "@" into value and condition part
    valcon = [string.(strip.(split(c, '@'))) for c in strip.(split(tag, r";(?![^(]*\))"))]
    # remove parentheses from condition part
    # split OR conditions (";") and move them into separate conditions
    orvalcon = [String[v, ci] for (v, c) in valcon for ci in string.(strip.(split(replace.(c, r"(\(|\))" => ""), ';')))]
    # split AND conditions ("AND") into elements of vector
    # create a dictionary with value and condition
    allconds = [Dict{String,Union{String,Vector}}(
        "value" => v,
        "conndition" => string.(strip.(split(c, r"(AND| and )")))
    ) for (v, c) in orvalcon]
    return allconds
end
