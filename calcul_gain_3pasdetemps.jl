include("calcul_gain.jl")
include("proba.jl")
include("tools.jl")

function calcul_capa_restante(Capa, Itineraires, temps, demande_per, leg_to_it)
    n = length(Capa)
    for i = 1:n
        itin_act = leg_to_it[i]
        for j in itin_act
            if !(j % 3 == 0)
                Capa[i] = max(Capa[i] - demande_per[j], 0)
            end
        end
    end
    return Capa
end

function calcul_capa_restante_newFiles(Capa, Itineraires, temps, demande_per, leg_to_it, place_itin=5, place_capa=4)
    n = length(Capa)
    for i = 1:n
        itin_act = leg_to_it[i]
        for j in 2:length(itin_act)
            Capa[i] = max(Capa[i] - demande_per[itin_act[j]], 0)
        end
    end
    return Capa
end


function gain_total(proba, prix, Itineraires, leg_to_it, nbre_pas_tps)
    gain_tot = 0.
    nbvols = length(Itineraires)
    Capa = lecture_capa(parser_import("Capacites2.csv"))
    for i = 1:nbre_pas_tps
        Demande = parser_chiffre(parser_import("DemandeT"*string(i-1)*".csv"), [], [1])
        nbpers = length(Demande)
        proba_actuelle = proba[i]
        demande_per = lecture_demande(Demande, nbpers, nbvols, proba_actuelle)
        Capa = calcul_capa_restante(Capa, Itineraires, i, demande_per, leg_to_it)
        gain_tot += gain(prix[i], demande_per)
    end
    return gain_tot
end

function gain_total_newFiles(proba, prix, Itineraires, leg_to_it, nbre_pas_tps)
    gain_tot = 0.
    nbvols = length(Itineraires)
    Capa = lecture_capa(parser_import("DataCreation/Data/little0/flight.csv"))
    Demande = parser_chiffre(parser_import("DataCreation/Data/little0/OnD.csv"), [6])
    for i = 1:nbre_pas_tps
        nbpers = length(Demande)
        proba_actuelle = proba[i]
        demande_per = lecture_demande_newFiles(Demande, Itineraires, proba_actuelle)
        Capa = calcul_capa_restante_newFiles(Capa, Itineraires, i, demande_per, leg_to_it)
        gain_tot += gain(prix[i], demande_per)
    end
    return gain_tot
end
