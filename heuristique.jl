include("parser.jl")
include("proba.jl")
include("FonctionRemplissage.jl")
include("calcul_gain.jl")

Capa = parser_chiffre(parser_import("Capacites2.csv"), [1])

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
        append!(Prix, parse(Int32, Donnees[i][prix]))
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

function heuristique_voisinage(nb_iter, Prix, Increase = 50)
    leg_to_it, it_to_leg = separer_itineraire(Itineraires, 2, 4)
    Prix_max = Prix
    for i = 1:nb_iter
        for j = 1:length(Capa)
            if dem<cap
                for k = 1:length(leg_to_it[j])
                    P[leg_to_it[j][k]] += Increase
                end
            else
                for k = 1:length(leg_to_it[j])
                    P[leg_to_it[j][k]] -= Increase
                end
            end
        end
        if gain>g
            Prix_max = Prix
        end
    end
    return Prix_max
end
