struct RoadRelationAttribute
    restriction_car::Symbol
end


function road_relation_attributes(tags)
    if get(tags, "type", "") != "restriction"
        return nothing
    end
    restriction_car = relation_car_restriction(tags)
    if restriction_car !== nothing
        attr = RoadRelationAttribute(restriction_car)
    else
        return nothing
    end

    return attr
end


function relation_car_restriction(tags)
    if get(tags, "type", "") != "restriction"
        return nothing
    end
    if haskey(RESTRICTION, get(tags, "restriction:motorcar", ""))
        restriction = RESTRICTION[get(tags, "restriction:motorcar", "")]
    elseif haskey(RESTRICTION, get(tags, "restriction", "")) && get(tags, "except", "") != "motorcar"
        restriction = RESTRICTION[get(tags, "restriction", "")]
    else
        restriction = nothing
    end
    # restriction_conditional = tokenize_conditional(get(tags, "restriction:conditional", nothing))
    # if haskey(RESTRICTION, restriction_conditional[1]["value"])
    #     restriction_value = RESTRICTION[restriction_conditional[1]["value"]]
    #     restriction_condition = restriction_conditional[1]["condition"]
    # end
    return restriction
end

# function rels_proc(tags,)
#     if get(tags, "type", "") != "route"
#         return nothing
#     end
#     if get(tags, "route", "") == "bicycle" || get(tags, "route", "") == "mtb"
#         bike_mask = 0
#         if get(tags, "network", "") == "mtb" || get(tags, "route", "") == "mtb"
#             bike_mask = 8
#         end
#         if get(tags, "network", "") == "ncn"
#             bike_mask = bike_mask | 1
#         elseif get(tags, "network", "") == "rcn"
#             bike_mask = bike_mask | 2
#         elseif get(tags, "network", "") == "lcn"
#             bike_mask = bike_mask | 4
#         end
#     end
# end
