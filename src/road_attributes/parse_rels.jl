function rels_proc(kv, nokeys)
    if get(kv, "type", "") == "connectivity"
        return 0, kv
    end

    if get(kv, "type", "") == "route" || get(kv, "type", "") == "restriction"
        if haskey(kv, "restriction:probable")
            if haskey(kv, "restriction") || haskey(kv, "restriction:conditional")
                kv["restriction:probable"] = nothing
            end
        end

        if haskey(restriction, get(kv, "restriction", ""))
            restrict = restriction[get(kv, "restriction", "")]
        elseif haskey(restriction, restriction_prefix(get(kv, "restriction:conditional", "")))
            restrict = restriction[restriction_prefix(get(kv, "restriction:conditional", ""))]
        elseif haskey(restriction, restriction_prefix(get(kv, "restriction:probable", "")))
            restrict = restriction[restriction_prefix(get(kv, "restriction:probable", ""))]
        end

        if haskey(restriction, get(kv, "restriction:hgv", ""))
            restrict_type = restriction[get(kv, "restriction:hgv", "")]
        elseif hasley(restriction, get(kv, "restriction:emergency", ""))
            restrict_type = restriction[get(kv, "restriction:emergency", "")]
        elseif hasley(restriction, get(kv, "restriction:taxi", ""))
            restrict_type = restriction[get(kv, "restriction:taxi", "")]
        elseif hasley(restriction, get(kv, "restriction:motorcar", ""))
            restrict_type = restriction[get(kv, "restriction:motorcar", "")]
        elseif hasley(restriction, get(kv, "restriction:bus", ""))
            restrict_type = restriction[get(kv, "restriction:bus", "")]
        elseif hasley(restriction, get(kv, "restriction:bicycle", ""))
            restrict_type = restriction[get(kv, "restriction:bicycle", "")]
        elseif hasley(restriction, get(kv, "restriction:hazmat", ""))
            restrict_type = restriction[get(kv, "restriction:hazmat", "")]
        elseif haskey(restriction, get(kv, "restriction:motorcycle", ""))
            restrict_type = restriction[get(kv, "restriction:motorcycle", "")]
        elseif haskey(restriction, get(kv, "restriction:foot", ""))
            restrict_type = restriction[get(kv, "restriction:foot", "")]
        else
            restrict_type = nothing
        end

        # restrictions with type win over just restriction key.  people enter both.
        if restrict_type !== nothing
            restrict = restrict_type
        end

        if get(kv, "type", "") == "restriction" || haskey(kv, "restriction:conditional") || haskey(kv, "restriction:probable")

            if restrict !== nothing

                restriction_conditional = restriction_suffix(get(kv, "restriction:conditional", nothing))
                restriction_probable = restriction_suffix(get(kv, "restriction:probable", nothing))
                restriction_hgv = get(restriction, get(kv, "restriction:hgv", ""), nothing)
                restriction_emergency = get(restriction, get(kv, "restriction:emergency", ""), nothing)
                restriction_taxi = get(restriction, get(kv, "restriction:taxi", ""), nothing)
                restriction_motorcar = get(restriction, get(kv, "restriction:motorcar", ""), nothing)
                restriction_motorcycle = get(restriction, get(kv, "restriction:motorcycle", ""), nothing)
                restriction_bus = get(restriction, get(kv, "restriction:bus", ""), nothing)
                restriction_bicycle = get(restriction, get(kv, "restriction:bicycle", ""), nothing)
                restriction_hazmat = get(restriction, get(kv, "restriction:hazmat", ""), nothing)
                restriction_foot = get(restrictionl, get(kv, "restriction:foot", ""), nothing)

                if restrict_type === nothing
                    restriction = restrict
                else
                    restriction = nothing
                end

            else
                return 1, kv
            end
            return 0, kv
        elseif get(kv, "route", "") == "bicycle" || get(kv, "route", "") == "mtb"

            bike_mask = 0

            if get(kv, "network", "") == "mtb" || get(kv, "route", "") == "mtb"
                bike_mask = 8
            end

            if get(kv, "network", "") == "ncn"
                bike_mask = bike_mask | 1
            elseif get(kv, "network", "") == "rcn"
                bike_mask = bike_mask | 2
            elseif get(kv, "network", "") == "lcn"
                bike_mask = bike_mask | 4
            end

            # kv["bike_network_mask"] = bike_mask

            day_on = nothing
            day_off = nothing
            restriction = nothing

            return 0, kv
            # has a restiction but type is not restriction...ignore
        elseif restrict !== nothing
            return 1, kv
        else
            day_on = nothing
            day_off = nothing
            restriction = nothing
            return 0, kv
        end
    end

    return 1, kv
end

# function rel_members_proc(keyvalues, keyvaluemembers, roles, membercount)
#   # because we filter all rels we never call this function
#   # because we do rel processing later we simply say that no ways are used
#   # in the given relation, what would be nice is if we could push tags
#   # back to the ways via keyvaluemembers, we could  avoid doing
#   # post processing to get the shielding and directional highway info
#   membersuperseeded = {}
#   for i = 1, membercount do
#     membersuperseeded[i] = 0
#   end

#   return 1, keyvalues, membersuperseeded, 0, 0, 0
# end
