include("parser.jl")

function lecture_capa(Capacites, numero_cap)
    #Initialisation des capacites
    leg = length(Capacites)
    cap = zeros(leg)
    for i = 1:leg
        cap[i] = parse(Int, Capacites[i][numero_cap])
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
function Augmentation(L, nbre, indice, deb = 1)
    for i = deb:length(L)
        L[i][indice] += nbre
    end
    return L
end

function Diminution(L, nbre, indice, deb = 1)
    for i = deb:length(L)
        L[i][indice] -= nbre
    end
    return L
end


function prix_ref(prix = 8, nb_pas_tps = 3)
    Donnees = parser_import("Itineraire_escales_prix_temps.csv")
    Prix = []
    for i = prix:nb_pas_tps + prix - 1
        L = []
        for j = 1:length(Donnees)
            append!(L, parse(Int32, Donnees[j][i]))
        end
        append!(Prix, [L])
    end
    return Prix
end

function prix_test(prix = 8)
    Donnees = parser_import("Itineraire_escales_prix_temps.csv")
    Prix = []
    for i = 1:length(Donnees)
        append!(Prix, [[parse(Float32, Donnees[i][prix])]])
    end
    return Prix
end

function test_inf(L, Increase, indice)
    for i in 1:length(L)
        if L[i][indice] < Increase
            return false
        end
    end
    return true
end

function egal_list(A, B)
    for i in 1:length(B)
        for j in 1:length(B[i])
            A[i][j] = B[i][j]
        end
    end
end

function capacite_end(nbre_pas_tps, Itineraires, alpha, proba, leg_to_it, it_to_leg)
    C = lecture_capa(parser_import("Capacites2.csv"))
    for i in 1:nbre_pas_tps
        C = capacite_finale(C, i-1, Itineraires, alpha, proba, leg_to_it, it_to_leg)
    end
    return C
end

function capacite_end_precis(nbre_pas_tps, Itineraires, alpha, proba, leg_to_it, it_to_leg)
    C = lecture_capa(parser_import("Capacites2.csv"))
    I = [0 for i in 1:length(C)]
    for i in 1:nbre_pas_tps
        C = capacite_finale(C, i-1, Itineraires, alpha, proba, leg_to_it, it_to_leg)
        for j in 1:length(C)
            if C[j] == 0
                I[j] = i
            end
        end
    end
    return C, I
end
