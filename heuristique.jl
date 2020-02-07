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

function Augmentation(L, nbre)
    for i = 1:length(L)
        L[i] += nbre
    end
    return L
end

function Diminution(L, nbre)
    for i = 1:length(L)
        L[i] -= nbre
    end
    return L
end

function heuristique_alea(nb_iter, Prix, Increase = 50)
    Prix_max = Prix
    for i = 1:nb_iter
        P = Prix_max
        a = rand(1:length(P))
        b = rand(1:2)
        if b == 1
            Augmentation(P[a], Increase)
        else
            Diminution(P[a], Increase)
        end
        if gain(P)>gain(Prix_max)
            Prix_max = P
        end
    end
    return Prix_max
end

function heuristique_voisinage()
end
