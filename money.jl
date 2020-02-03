function parser_chiffre(A, lettre = 6)
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

function itineraire(Donnees, debut, fin)
    It = []
    for i = 1:length(Donnees)
        L = []
        for j = debut:fin
            append!(L, Donnees[i][j])
        end
        append!(It, [L])
    end
    return It
end

function taille(It)
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
end

function separer_itineraire(Donnees, class = 5, prix = 6)
    Bui = []
    Eco = []
    for i = 1:length(Donnees)

end
