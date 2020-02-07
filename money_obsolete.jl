function parser_chiffre(A, lettre = 6)
    # fonction qui prend en argument les donnees et qui renvoit uniquement
    # donnees de type entier
    Donnees = []
    for i = 1:length(A)
        L = []
        for j = 1:length(A[i])
            if (j != lettre)
                append!(L, parse(Int32, A[i][j]))
            end
        end
        append!(Donnees, [L])
    end
    return Donnees
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

function portion(It)
    T = taille(It)
    P = []
    I = []
    for i = 1:length(T)
        if T[i]==2
            L = [It[i][1], It[i][2]]
            if !(L in P)
                append!(P, [L])
                append!(I, i)
            end
        end
    end
    return P
end

function id(L, Donnees, debut, fin, Ec, taille, class=5)
    for i = 1:length(Donnees)
        if L == Donnees[i][debut:fin] && Donnees[i][class]==Ec && taille[i]==2
            return i
        end
    end
    return false
end

function put(k, i, A)
    for j = 1:length(A)
        if A[j][1] == k
            append!(A[j][2], i)
        end
    end
end

function separer_itineraire(Donnees, debut, fin, class = 5)
    # fonction qui renvoit tout les itineraires de 1 en 1 aeroport et
    # tous les itineraires qui sont liés à cette portion

    Bui = []
    Eco = []
    It = itineraire(Donnees, debut, fin)
    T = taille(It)
    P = portion(It)
    for i = 1:length(Donnees)
        if T[i]==2
            if Donnees[i][class]==0
                append!(Bui, [[i,[i]]])
            elseif Donnees[i][class]==1
                append!(Eco, [[i,[i]]])
            end
        end
    end
    for i = 1:length(Donnees)
        if T[i]!=2
            for j = 1:T[i]-1
                L = [It[i][j], It[i][j+1]]
                if Donnees[i][class]==1
                    k = id(L, Donnees, debut, debut+1, 1, T)
                    put(k, i, Eco)
                elseif Donnees[i][class]==0
                    k = id(L, Donnees, debut, debut+1, 0, T)
                    put(k, i, Bui)
                end
            end
        end
    end
    return Eco, Bui
end

function modification(x)
    return 2*x
end

function money(Donnees, taille, lien, prix = 6)
    P = itineraire(Donnees, prix, prix, false)
    for i = 1:length(P)
        if taille[i]==2
            P[i] = modification(P[i])
        else
            P[i] = 0
        end
    end
    for n = 1:length(lien)
        for i = 1:length(lien[n])
            k = lien[n][i][1]
            for j = 1:length(lien[n][i][2])
                if taille[lien[n][i][2][j]]!=2
                    P[lien[n][i][2][j]] += P[k]
                end
            end
        end
    end
    return P
end

clearconsole()
