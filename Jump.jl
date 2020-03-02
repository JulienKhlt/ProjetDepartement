include("parser.jl")
include("tools.jl")
include("proba.jl")
include("FonctionRemplissage.jl")
include("calcul_gain.jl")

Capa = lecture_capa(parser_import("Capacites2.csv"))


using JuMP
uding Clp



m = Model(solver = ClpSolver)

@variable(m,q[i=1:length(Itneraires)] >=0)
@constraint(m,CapaciteLeg[i=1:length(Capa)], sum(q[j] for j in separer_itineraire(2,4)[i]) <= Capa[i] )
@constraint(m,DemandeOD[i=1:NombreOD], sum(q[j] for j in LegInclusOD(i))= DemandeOD(i))

for j=1:NombreOD
     @constraint(m,Attractivite[i=1:NombreItineraireAssoc(j)], q[i]/a[i] <= q[i0]/a[i0] )
end


@objective(m, Max, sum(q[i]*v[i] for i=1:length(Itneraires)))


status = solve(m)

println("Objective value: ", getobjectivevalue(m))
println("repartition = ", getvalue(q))
