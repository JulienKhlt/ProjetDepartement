include("parser.jl")

function lecture_capa(Capacites)
    #Initialisation des capacites
    leg = length(Capacites)
    cap = zeros(leg)
    for i = 1:leg
        cap[i] = parse(Int, Capacites[i][4])
        #cap[i] représente la capacité du leg i
    end
    return cap
end



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

function vol()
    P = parser_import("Capacites2.csv")
    legs = parser_chiffre(P, [1,4])
    return legs
end

function id(It, taille, class=5, nb_class=2)
    legs = vol()
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
    legs = vol()
    G = []
    for i = 1:length(Donnees)
        if T[i]==2
            if Donnees[i][class] == nb_class
                append!(leg_to_it, [[i]])
                append!(G, i)
                L = [It[i][1], It[i][2]]
                for l = 1:length(legs)
                    if L == legs[l]
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

function ODandIt(Donnees, Demande)
    OD_to_it = [[] for i in 1:length(Demande)]
    t = taille(itineraire(Donnees, 2, 4)) #t=2 s'il n'y a pas d'escale, 3 sinon
    for id_OD in 1:length(Demande)
        a1 = Demande[id_OD][1]
        a2 = Demande[id_OD][2]
        for id_itin in 1:length(Donnees)
            b1 = Donnees[id_itin][2]
            if b1 == a1
                b2 = Donnees[id_itin][1+t[id_itin]]
                if b2 == a2
                    append!(OD_to_it[id_OD], id_itin)
                end
            end
        end
    end
    return OD_to_it
end
