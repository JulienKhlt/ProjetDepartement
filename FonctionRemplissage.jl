include("parser.jl")
include("tools.jl")
include("proba.jl")


#l est la capacité à l'instant t
function capacite_finale(l, t, prix_a_t, Itineraires, alpha, proba, OD_to_it, leg_to_it, it_to_leg)
    if t == 0
        deman = parser_chiffre(parser_import("DemandeT0.csv"), [1])
    elseif t == 1
        deman = parser_chiffre(parser_import("DemandeT1.csv"), [1])
    elseif t == 2
        deman = parser_chiffre(parser_import("DemandeT2.csv"), [1])
    end
    OD_to_it = ODandIt(Itineraires, deman)
    P = proba[t+1]
    nb_demande=[[0, 0] for i in 1:length(Itineraires)]
    capa_fin = [0. for i = 1:length(l)]
    for i in 1:length(l)
        capa_fin[i] = l[i]
    end
    for id_OD in 1:length(deman)
        for id_itin in OD_to_it[id_OD]
            # -1 et -2 symbolisent les classes de personnes
            if deman[id_OD][4] == -2
                nb_demande[id_itin][1] = deman[id_OD][3]
            elseif deman[id_OD][4] == -1
                nb_demande[id_itin][2] = deman[id_OD][3]
            end
        end
    end
    for id_itin in 1:length(Itineraires)
        for id_vol in 1:length(leg_to_it)
            capa_fin[id_vol] = max(capa_fin[id_vol] - (P[id_itin]) * nb_demande[id_itin][1], 0)
            capa_fin[id_vol] = max(capa_fin[id_vol] - (P[length(Itineraires) + id_itin]) * nb_demande[id_itin][2], 0)
        end
    end
    return capa_fin
end
