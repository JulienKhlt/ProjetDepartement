include("parser.jl")
include("proba.jl")
include("FonctionRemplissage.jl")
include("calcul_gain.jl")

Capa = lecture_capa(parser_import("Capacites2.csv"))

function prix_ref(prix = 8)
    Donnees = parser_import("Itineraire_escales_prix_temps.csv")
    Prix = []
    for i = 1:length(Donnees)
        L = []
        for j = prix:length(Donnees[i])
            append!(L, parse(Int32, Donnees[i][j]))
        end
        append!(Prix, [L])
    end
    return Prix
end

function prix_test(prix = 8)
    Donnees = parser_import("Itineraire_escales_prix_temps.csv")
    Prix = []
    for i = 1:length(Donnees)
        append!(Prix, parse(Float32, Donnees[i][prix]))
    end
    return Prix
end

function heuristique_alea(nb_iter, Prix, Increase = 50)
    Prix_max = Prix
    for i = 1:nb_iter
        P = Prix_max
        a = rand(1:length(P))
        b = rand(1:2)
        if b == 1
            P[a] += Increase
        else
            P[a] -= Increase
        end
        if gain(P) > gain(Prix_max)
            Prix_max = P
        end
    end
    return Prix_max
end

function heuristique_voisinage(nb_iter, Prix, Increase = 20)
    leg_to_it, it_to_leg = separer_itineraire(Itineraires, 2, 4)
    Prix_max = Prix
    truc, alpha = prix_alpha(Itineraires, 1)
    for i = 1:nb_iter
        C = capacite_finale(Capa, 0, Prix)
        Proba = calcdonnee(Prix, alpha)
        for j = 1:length(Capa)
            if C[j]==0
                for k in leg_to_it[j]
                    Prix[k] += Increase
                end
            else
                for k in leg_to_it[j]
                    if Prix[k] - Increase > 0
                        Prix[k] -= Increase
                    end
                end
            end
        end
        if gain("Itineraire_escales_prix_temps.csv", "DemandeT0.csv", "Capacites2.csv", Proba, Prix, 1) > gain("Itineraire_escales_prix_temps.csv", "DemandeT0.csv", "Capacites2.csv", Proba, Prix_max, 1)
            Prix_max = Prix
        end
    end
    return Prix_max
end
