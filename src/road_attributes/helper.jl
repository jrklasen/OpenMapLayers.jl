
"""
Maxspeed tag as number
"""
function parse_maxspeed(tag::Union{AbstractString,Nothing})::Union{Int,Missing}
    if tag === nothing
        return missing
    end
    if tag === "none"
        return Inf
    end
    # turn commas into dots to handle European-style decimal separators
    tag = replace(tag, "," => ".")
    number = match(r"[+-]?((\d+\.?\d*)|(\.\d+))", tag)
    if number !== nothing
        number = parse(Float64, number.match)
        unit = match(r"(km/h|kmh|kph|mph|knots)$", tag)
        if unit === nothing
            return Int(floor(number))
        else
            if unit.match === nothing
                return Int(floor(number))
            elseif unit.match in ["km/h", "kmh", "kph"]
                return Int(floor(number))
            elseif unit.match === "mph"
                return Int(floor(number * 1.609))
            elseif unit.match === "knots"
                return Int(floor(number * 1.852))
            end
        end
    else
        return missing
    end
end

"""
dimension
"""
function parse_dimension(tag::Union{AbstractString,Nothing})::Union{Real,Missing}
    if tag === nothing
        return missing
    end
    # turn commas into dots to handle European-style decimal separators
    tag = replace(tag, "," => ".")
    number = match(r"[+-]?((\d+\.?\d*)|(\.\d+))", tag)
    if number !== nothing
        number = parse(Float64, number.match)
        unit = match(r"(m|meter|meters|cm|ft|feet|foot|in|inch|inches)$", tag)
        if unit === nothing
            return round(number, 2)
        else
            if unit.match === nothing
                return round(number, 2)
            elseif unit.match in ["m", "meter", "meters"]
                return round(number, 2)
            elseif unit.match === "cm"
                return round(number * 0.01, 2)
            elseif unit.match in ["ft", "feet", "foot"]
                return round(number * 0.3048, 2)
            elseif unit.match in ["in", "inch", "inches"]
                return round(number * 0.0254, 2)
            end
        end
    else
        return missing
    end
end

"""
weight
"""
function parse_weight(tag::Union{AbstractString,Nothing})::Union{Real,Missing}
    if tag === nothing
        return missing
    end
    # turn commas into dots to handle European-style decimal separators
    tag = replace(tag, "," => ".")
    number = match(r"[+-]?((\d+\.?\d*)|(\.\d+))", tag)
    if number !== nothing
        number = parse(Float64, number.match)
        unit = match(r"(t|tonne|tonnes|kg|lb|lbs)$", tag)
        if unit === nothing
            return round(number, 2)
        else
            if unit.match === nothing
                return round(number, 2)
            elseif unit.match in ["t", "tonne", "tonnes"]
                return round(number, 2)
            elseif unit.match === "kg"
                return round(number * 0.001, 2)
            elseif unit.match in ["lb", "lbs"]
                return round(number * 0.0005, 2)
            end
        end
    else
        return missing
    end
    return missing
end

function lanecount(tag)
    if tag === nothing
        return missing
    end
    number = match(r"[+-]?((\d+\.?\d*)|(\.\d+))", tag)
    if number !== nothing
        lanes = parse(Int64, number.match)
        if lanes > 15
            lanes = missing
        end
    else
        lanes = nothing
    end
    return lanes
end



function ways_proc(kv, nokeys)
    # if there were no tags passed in, ie keyvalues is empty
    if nokeys == 0
        then
        return 1, kv, 0, 0
    end

    # does it at least have some interesting tags
    filter = filter_tags_generic(kv)

    # let the caller know if its a keeper or not and give back the  modified tags
    # also tell it whether or not its a polygon or road
    return filter, kv, 0, 0
end



########################################################################################################################


function restriction_prefix(restriction_str)
    #not a string
    if restriction_str == missing
        return missing
    end

    #find where the restriction type ends.
    #format looks like
    #restriction:conditional=no_left_turn @ (07:00-09:00,15:30-17:30)
    local index = 0
    local found = false
    for c in restriction_str:gmatch"."
        if c == "@"
            found = true
            break
        end
        if c != " "
            index = index + 1
        end
    end

    #@ symbol did not exist
    if found == false
        return missing
    end

    #return the type of restriction
    return restriction_str:sub(0, index)
end

function restriction_suffix(restriction_str)
    #not a string
    if restriction_str == missing
        return missing
    end

    #find where the restriction type ends.
    #format looks like
    #restriction:conditional=no_left_turn @ (07:00-09:00,15:30-17:30)
    local index = 0
    local found = false
    for c in restriction_str:gmatch"."

        if found
            if c != " "
                index = index + 1
                break
            end
        elseif c == "@"
            found = true
        end
        index = index + 1
    end

    #@ symbol did not exist
    if found == false
        return missing
    end

    #return the date && time information for the restriction
    return restriction_str:sub(index, string.len(restriction_str))
end


#convert the numeric (non negative) number portion at the beginning of the string
function numeric_prefix(num_str, allow_decimals)
    #not a string
    if num_str == missing
        return missing
    end

    #find where the numbers stop
    local index = 0
    # flag to say if we've seen a decimalt already. we shouldn't allow two,
    # otherwise the call to tonumber() might fail.
    local seen_dot = false
    for c in num_str:gmatch"."
        if tonumber(c) == missing
            if c == "."
                if allow_decimals == false || seen_dot
                    break
                end
                seen_dot = true
            else
                break
            end
        end
        index = index + 1
    end

    #there weren't any numbers
    if index == 0
        return missing
    end

    #Returns the substring that's numeric at the start of num_str
    return num_str:sub(0, index)
end


# Returns true if the only payment types present are cash. Example payment kv's look like:
# payment:cash=yes
# payment:credit_cards=no
# There can be multiple payment types on a given way/node. This routine determines
# if the payment types on the way/node are all cash types. There are (at the moment) 60
# types of payments, but only three are cash: cash, notes, coins.
# Examining the types of values you might find for 'payment:coins' the predominant
# usages are 'yes' && 'no'. However, there are also some values like '$0.35' && 'euro'.
# Hence, this routine considers ~'NO' an affirmative value.
function is_cash_only_payment(kv)
    local allows_cash_payment = false
    local allows_noncash_payment = false
    for (key, value) in pairs(kv)
        if string.sub(key, 1, 8) == "payment:"
            local payment_type = string.sub(key, 9, -1)
            local is_cash_payment_type = payment_type == "cash" || payment_type == "notes" || payment_type == "coins"
            if (is_cash_payment_type && allows_cash_payment == false)
                allows_cash_payment = string.upper(value) != "NO"
            end
            if (is_cash_payment_type == false && allows_noncash_payment == false)
                allows_noncash_payment = string.upper(value) != "NO"
            end
        end
    end

    return allows_cash_payment && allows_noncash_payment == false
end
