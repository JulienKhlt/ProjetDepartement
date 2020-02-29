include("calcul_gain.jl")
include("proba.jl")
include("tools.jl")

function calcul_capa_restante(Capa, Itineraires, temps, demande_per, leg_to_it)
    n = length(Capa)
    for i = 1:n
        itin_act = leg_to_it[i]
        for j in itin_act
            Capa[i] = Capa[i]-demande_per[j]
        end
    end
    return C
end


function gain_total(proba, prix, Itineraires, leg_to_it, nbre_pas_tps)
    gain_tot = 0.
    Capa = lecture_capa(parser_import("Capacites2.csv"))
    for i = 1:nbre_pas_tps
        Demande = parser_chiffre(parser_import("DemandeT"*string(i-1)*".csv"),[1])
        proba_actuelle = proba[i]
        println(Capa)
        demande_per = gestion_cap(Itineraires, Demande, Capa, proba_actuelle, i, leg_to_it)
        println(demande_per)
        Capa = calcul_capa_restante(Capa, Itineraires, i, demande_per, leg_to_it)
        println(Capa)
        gain_tot += gain(Itineraires, Demande, Capa, proba_actuelle, prix[i], i, demande_per)
    end
    return gain_tot
end
