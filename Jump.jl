include("parser.jl")
include("tools.jl")
include("proba.jl")
include("calcul_gain.jl")

Capa = lecture_capa(parser_import("DataCreation/Data/little0/flight.csv"))


OnD = parser_chiffre(parser_import("DataCreation/Data/little0/OnD.csv"), [6])
flight = parser_chiffre(parser_import("DataCreation/Data/little0/flight.csv"), [5])
itineraries = parser_chiffre(parser_import("DataCreation/Data/little0/itineraries.csv"), [5,7], [6])


using JuMP
using Clp

function carotte(v)

    m = Model(solver = ClpSolver)

    @variable(m,q[i=1:length(itneraries)] >=0)
    @constraint(m,CapaciteLeg[i=1:length(Capa)], sum(q[j] for j in itineraries[i][7]) <= Capa[i] )
    @constraint(m,DemandeOD[i=1:length(OnD)], sum(q[j] for j in OnD[i][6])= OnD[i][4]+OnD[i][5])

    for j=1:length(OnD)
         @constraint(m,Attractivite[i in OnD[j][6]], q[i]/itineraries[i][6] <= q[OnD[j][6]]/itineraries[OnD[j][6]][6] )
    end


    @objective(m, Max, sum(q[i]*v[i] for i=1:length(itneraries)))


    status = solve(m)

    println("Objective value: ", getobjectivevalue(m))
    println("repartition = ", getvalue(q))
end
