# Generic function that create a csv
function write_new_file(filename, header, lines)
    open(filename, "w") do file
        if header != ""
            header_string = string(header, "\n")
        else
            header_string = string(header)
        end
        write(file, header_string)
        for line in lines
            line_written = string(line, "\n")
            write(file, line_written)
        end
    end
end

# function that create the flight file
function write_flight_file(folder_name, list_flights, links)
    header = "id;depart;arrivee;capacite du vol;list_itineraires"
    list_lines = []

    for flight in list_flights
        line = string(flight.id, ";", flight.airport_dep, ";", flight.airport_arr, ";", flight.capacity, ";", links.flight_to_itin[flight.id])
        push!(list_lines, line)
    end

    write_new_file(string(folder_name, "/flight.csv"), header, list_lines)
end

# function that create the itinerary file
function write_itinerary_file(folder_name, list_itineraries, links)
    header = "id;depart;arrivee;OnD;list_airports;alpha;list_flights"
    list_lines = []

    for itinerary in list_itineraries
        if itinerary.list_visited_airports == []
            line = string(itinerary.id, ";", itinerary.departure, ";", itinerary.arrival, ";", itinerary.OnD, ";[];", itinerary.alpha, ";", links.itin_to_flight[itinerary.id])
            push!(list_lines, line)
        else
            line = string(itinerary.id, ";", itinerary.departure, ";", itinerary.arrival, ";", itinerary.OnD, ";", itinerary.list_visited_airports, ";", itinerary.alpha, ";", links.itin_to_flight[itinerary.id])
            push!(list_lines, line)
        end
    end

    write_new_file(string(folder_name, "/itineraries.csv"), header, list_lines)
end

# function that create the OnD file
function write_OnD_file(folder_name, list_OnDs, links)
    header = "id;depart;arrivee;demand_business;demand_family;list_itineraires"
    list_lines = []

    for OnD in list_OnDs
        line = string(OnD.id, ";", OnD.origin, ";", OnD.destination, ";", OnD.demand_buisiness, ";", OnD.demand_family, ";", links.Ond_to_itin[OnD.id])
        push!(list_lines, line)
    end

    write_new_file(string(folder_name, "/OnD.csv"), header, list_lines)
end

# function that build a folder
function create_folder(folder_name)
    if folder_name[end] == '/'
        folder_name = folder_name[1:end-1]
    end
    final_name = folder_name
    i = 0
    while ispath(final_name)
        final_name = string(folder_name, string(i))
        i += 1
    end
    final_name = string(final_name, '/')
    mkdir(final_name)
    return final_name
end

# Function that build a whole database
function create_database(name_folder, list_flights, list_itineraries, list_OnDs, links)
    name_folder = create_folder(string("Data/", name_folder, "/"))
    write_flight_file(name_folder, list_flights, links)
    write_itinerary_file(name_folder, list_itineraries, links)
    write_OnD_file(name_folder, list_OnDs, links)
end
