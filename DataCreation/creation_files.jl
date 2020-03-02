using Random

# Structured used
struct Airports
    id::Int64
    period::Int64
end

struct Flights
    id::Int64
    airport_dep::Int64
    airport_arr::Int64
    capacity::Int64
end

struct OnD
    id::Int64
    origin::Int64
    destination::Int64
    demand_buisiness::Int64
    demand_family::Int64
end

struct Itinerary
    id::Int64
    departure::Int64
    arrival::Int64
    OnD::Int64
    list_visited_airports::Array{Int64, 1}
    alpha::Float64
end

struct CrossData
    flight_to_itin::Array{Array{Int64, 1}, 1}
    itin_to_flight::Array{Array{Int64, 1}, 1}
    itin_to_OnD::Array{Int64, 1}
    Ond_to_itin::Array{Array{Int64, 1}, 1}
end

# Creation of the flight graph
function create_graph(nb_node_min, nb_node_max, nb_edge_1_min, nb_edge_1_max, nb_edge_2_min, nb_edge_2_max, capa_poss, nb_per)
    rng = MersenneTwister(1234)
    list_airports = Array{Airports, 1}()
    list_flights = Array{Flights, 1}()
    airport_to_flight_in = Array{Array{Int64, 1}, 1}()
    airport_to_flight_out = Array{Array{Int64, 1}, 1}()
    list_per_to_node = Array{Array{Int64, 1}, 1}()
    per_to_nb_node = Array{Int64, 1}()
    airport_id = 0
    flight_id = 0
    for per in 1:nb_per
        nb_nodes_per = rand(nb_node_min:nb_node_max)
        push!(per_to_nb_node, nb_nodes_per)
        push!(list_per_to_node, [])
        for i in 1:nb_nodes_per
            airport_id += 1
            push!(list_per_to_node[per], airport_id)
            push!(list_airports, Airports(airport_id, per))
            push!(airport_to_flight_in, [])
            push!(airport_to_flight_out, [])
        end
    end
    for per in 1:(nb_per-2)
        for departure in list_per_to_node[per]
            nb_edges_1 = min(per_to_nb_node[per+1], rand(nb_edge_1_min:nb_edge_1_max))
            nb_edges_2 = min(per_to_nb_node[per+2], rand(nb_edge_2_min:nb_edge_2_max))
            list_selected_1 = randperm(Random.seed!(rng), length(list_per_to_node[per+1]))[1:nb_edges_1]
            list_selected_2 = randperm(Random.seed!(rng), length(list_per_to_node[per+2]))[1:nb_edges_2]
            for k in list_selected_1
                arrival = list_per_to_node[per+1][k]
                flight_id += 1
                capa = rand(capa_poss)
                push!(list_flights, Flights(flight_id, departure, arrival, capa))
                push!(airport_to_flight_in[arrival], flight_id)
                push!(airport_to_flight_out[departure], flight_id)
            end
            for k in list_selected_2
                arrival = list_per_to_node[per+2][k]
                flight_id += 1
                capa = rand(capa_poss)
                push!(list_flights, Flights(flight_id, departure, arrival, capa))
                push!(airport_to_flight_in[arrival], flight_id)
                push!(airport_to_flight_out[departure], flight_id)
            end
        end
    end

    return list_airports, list_flights, airport_to_flight_in, airport_to_flight_out, list_per_to_node
end

# Function that creates an itinerary
function add_itinerary(list_it, i_t_OD, i_t_f, OD_t_i, id_it, id_od, d_node, a_node, list_nodes, list_f, alph)
    i_to_add = Itinerary(id_it, d_node, a_node, id_od, list_nodes, alph)
    push!(list_it, i_to_add)
    push!(i_t_OD, id_od)
    push!(i_t_f, list_f)
    push!(OD_t_i[id_od], id_it)
end

# Creation pf the Onds and the itineraries
function create_itineraries(per_t_n, airp, list_demand_busi, list_demand_fam, edg_out, list_flights)
    list_OnD = Array{OnD, 1}()
    list_itineraries = Array{Itinerary, 1}()
    id_OnD = 0
    id_itin = 0

    OD_to_id = Dict{Tuple{Int64, Int64}, Int64}()
    flight_to_itin = Array{Array{Int64, 1}, 1}()
    for i in list_flights
        push!(flight_to_itin, [])
    end
    itin_to_flight = Array{Array{Int64, 1}, 1}()
    itin_to_OnD = Array{Int64, 1}()
    Ond_to_itin = Array{Array{Int64, 1}, 1}()

    # Creation of the OnDs
    for k in 1:4
        for (i, period) in enumerate(per_t_n[1:end-k])
            for dep_node in period
                for arr_node in per_t_n[i+k]
                    id_OnD += 1
                    demand_b = rand(list_demand_busi)
                    demand_f = rand(list_demand_fam)
                    push!(list_OnD, OnD(id_OnD, dep_node, arr_node, demand_b, demand_f))
                    push!(Ond_to_itin, [])
                    OD_to_id[(dep_node, arr_node)] = id_OnD
                    # Itinerary no buy
                    id_itin += 1
                    alpha_no_buy = rand()
                    flight_associated = 0
                    for fl in list_flights[edg_out[dep_node]]
                        if fl.airport_arr == arr_node
                            flight_associated = fl.id
                        end
                    end
                    add_itinerary(list_itineraries, itin_to_OnD, itin_to_flight, Ond_to_itin, id_itin, id_OnD, dep_node, arr_node, [], [flight_associated], alpha_no_buy)
                end
            end
        end
    end

    # Creation of itineraries
    for period in per_t_n[1:end-2]
        for dep_node in period
            for flight_1 in list_flights[edg_out[dep_node]]
                aer_1 = flight_1.airport_arr
                used_OnD_1 = OD_to_id[(dep_node, aer_1)]
                visited_aer_1 = [dep_node, aer_1]
                id_itin += 1
                alpha_fam = rand()
                add_itinerary(list_itineraries, itin_to_OnD, itin_to_flight, Ond_to_itin, id_itin, used_OnD_1, dep_node, aer_1, visited_aer_1, [flight_1.id], alpha_fam)
                push!(flight_to_itin[flight_1.id], id_itin)
                id_itin += 1
                alpha_busi = rand() + 1
                add_itinerary(list_itineraries, itin_to_OnD, itin_to_flight, Ond_to_itin, id_itin, used_OnD_1, dep_node, aer_1, visited_aer_1, [flight_1.id], alpha_busi)
                push!(flight_to_itin[flight_1.id], id_itin)
                for id_fl_2 in edg_out[aer_1]
                    flight_2 = list_flights[id_fl_2]
                    aer_2 = flight_2.airport_arr
                    used_OnD_2 = OD_to_id[(dep_node, aer_2)]
                    visited_aer_2 = [dep_node, aer_1, aer_2]
                    id_itin += 1
                    alpha_fam = rand()
                    add_itinerary(list_itineraries, itin_to_OnD, itin_to_flight, Ond_to_itin, id_itin, used_OnD_2, dep_node, aer_2, visited_aer_2, [flight_1.id, flight_2.id], alpha_fam)
                    push!(flight_to_itin[flight_2.id], id_itin)
                    id_itin += 1
                    alpha_busi = rand() + 1
                    add_itinerary(list_itineraries, itin_to_OnD, itin_to_flight, Ond_to_itin, id_itin, used_OnD_2, dep_node, aer_2, visited_aer_2, [flight_1.id, flight_2.id], alpha_busi)
                    push!(flight_to_itin[flight_2.id], id_itin)
                end
            end
        end
    end

    # Itinerariess of the last period of the graph
    for dep_node in per_t_n[end-1]
        for flight in list_flights[edg_out[dep_node]]
            aer_1 = flight.airport_arr
            used_OnD = OD_to_id[(dep_node, aer_1)]
            visited_aer = [dep_node, aer_1]
            id_itin += 1
            alpha_fam = rand()
            add_itinerary(list_itineraries, itin_to_OnD, itin_to_flight, Ond_to_itin, id_itin, used_OnD, dep_node, aer_1, visited_aer, [flight.id], alpha_fam)
            push!(flight_to_itin[flight.id], id_itin)
            id_itin += 1
            alpha_busi = rand() + 1
            add_itinerary(list_itineraries, itin_to_OnD, itin_to_flight, Ond_to_itin, id_itin, used_OnD, dep_node, aer_1, visited_aer, [flight.id], alpha_busi)
            push!(flight_to_itin[flight.id], id_itin)
        end
    end
    links = CrossData(flight_to_itin, itin_to_flight, itin_to_OnD, Ond_to_itin)
    return list_OnD, list_itineraries, links
end
