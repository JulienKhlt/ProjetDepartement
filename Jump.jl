include("parser.jl")
include("tools.jl")
include("proba.jl")
include("calcul_gain.jl")





Capa = lecture_capa(parser_import("DataCreation/Data/little0/flight.csv"))


OnD = parser_chiffre(parser_import("DataCreation/Data/little0/OnD.csv"), [6])
flight = parser_chiffre(parser_import("DataCreation/Data/little0/flight.csv"), [5])
itineraries = parser_chiffre(parser_import("DataCreation/Data/little0/itineraries.csv"), [5,7], [6])
alpha = calculer_alpha(parser_import("DataCreation/Data/little0/itineraries.csv"))

using JuMP
using GLPK



function carotte(v)

    ##m = Model(GLPK.Optimizer)
    m = Model(with_optimizer(GLPK.Optimizer))


    @variable(m,q[i=0:length(itineraries)] >=0)
    @constraint(m,baba,q[0]==0)
    @constraint(m,CapaciteLeg[i=1:length(Capa)], sum(q[j] for j in itineraries[i][6]) <= Capa[i] )
    @constraint(m,DemandeOD[i=1:length(OnD)], sum(q[j] for j in OnD[i][6]) == OnD[i][4]+OnD[i][5])

    for j=1:length(OnD)
         @constraint(m,[i=1:length(OnD[j][6])], q[OnD[j][6][i]]/alpha[OnD[j][6][i]] <= q[OnD[j][6][1]]/alpha[OnD[j][6][1]] )
    end


    @objective(m, Max, sum(q[i]*v[i] for i=1:length(itineraries)))


    optimize!(m)

    println("Objective value: ", JuMP.objective_value(m))
    println("repartition = ", JuMP.value.(q))
end
