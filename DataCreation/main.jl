include("creation_files.jl")
include("csv_writer.jl")

# # Parameters big
nb_node_min, nb_node_max = 2, 4
nb_edge_1_min, nb_edge_1_max = 2, 4
nb_edge_2_min, nb_edge_2_max = 2, 4
capacities = [50, 60, 70, 80, 90, 100]
number_periods = 5
demand_business = [2, 4, 6, 8, 10]
demand_family = [30, 35, 40, 45, 50, 55, 60]

# Parameters moyen
# nb_node_min, nb_node_max = 3, 6
# nb_edge_1_min, nb_edge_1_max = 3, 5
# nb_edge_2_min, nb_edge_2_max = 2, 4
# capacities = [50, 60, 70, 80, 90, 100]
# number_periods = 10
# demand_business = [2, 4, 6, 8, 10]
# demand_family = [30, 35, 40, 45, 50, 55, 60]

# # Parameters big
# nb_node_min, nb_node_max = 4, 8
# nb_edge_1_min, nb_edge_1_max = 4, 6
# nb_edge_2_min, nb_edge_2_max = 3, 5
# capacities = [50, 60, 70, 80, 90, 100]
# number_periods = 20
# demand_business = [2, 4, 6, 8, 10]
# demand_family = [30, 35, 40, 45, 50, 55, 60]

# CReation of the database
airports, flights, a_t_in, a_t_out, per_t_n = create_graph(nb_node_min, nb_node_max, nb_edge_1_min, nb_edge_1_max, nb_edge_2_min, nb_edge_2_max, capacities, number_periods)
list_OD, list_itt, crossed_info = create_itineraries(per_t_n, airports, demand_business, demand_family, a_t_out, flights)

create_database("little", flights, list_itt, list_OD, crossed_info)
