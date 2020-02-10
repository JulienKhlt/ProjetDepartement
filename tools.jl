include("parser.jl")
include("money.jl")

It = parser_import("Itineraire_escales_prix_temps.csv")
Itineraires = parser_chiffre(It, [6,7])

function itineraire(Donnees, debut, fin, it = true)
    # fonction qui prend en argument les donnees, un indice de debut et de fin
    # et qui renvoit la liste des aeroports visite avec des 0 s'il n'y a plus
    # d'aeroport visite
    It = []
    for i = 1:length(Donnees)
        L = []
        for j = debut:fin
            append!(L, Donnees[i][j])
        end
        if it
            append!(It, [L])
        elseif !it
            append!(It, L)
        end
    end
    return It
end

function taille(It)
    # fonction qui renvoit pour chaque identifiant de voyage le nombre d'aeroports
    # qu'il visite
    L = []
    for i = 1 : length(It)
        A = 0
        for j = 1 : length(It[i])
            if It[i][j]!=0
                A += 1
            end
        end
        append!(L, A)
    end
    return L
end

function leg()
    P = parser_import("Capacites2.csv")
    legs = parser_chiffre(P, [1,4])
    return legs
end

function id(It, taille, class=5, nb_class=1.5)
    legs = leg()
    for j = 1:length(legs)
        for i = 1:length(It)
            if legs[j] == It[i][1:2] && It[i][class]==nb_class && taille[i]==2
                append(legs[j], [[i]])
            end
        end
    end
    return legs
end

function put(k, i, A)
    for j = 1:length(A)
        if A[j][1] == k
            append!(A[j][2], i)
        end
    end
end

function separer_itineraire(Donnees, debut, fin, class = 5, nb_class = 2)
    # fonction qui renvoit tout les itineraires de 1 en 1 aeroport et
    # tous les itineraires qui sont liés à cette portion

    leg_to_it = []
    it_to_leg = [[] for i=1:length(Donnees)]
    It = itineraire(Donnees, debut, fin)
    T = taille(It)
    legs = leg()
    G = []
    for i = 1:length(Donnees)
        if T[i]==2
            if Donnees[i][class] == nb_class
                append!(leg_to_it, [[i]])
                append!(G, i)
                L = [It[i][1], It[i][2]]
                for l = 1:length(legs)
                    if L == legs[l]
                        append!(leg_to_it[l], i)
                        append!(it_to_leg[i], l)
                    end
                end
            end
        end
    end
    for i = 1:length(Donnees)
        if ! (i in G)
            for j = 1:T[i]-1
                L = [It[i][j], It[i][j+1]]
                for l = 1:length(legs)
                    if L == legs[l]
                        append!(leg_to_it[l], i)
                        append!(it_to_leg[i], l)
                    end
                end
            end
        end
    end
    return leg_to_it, it_to_leg
end
