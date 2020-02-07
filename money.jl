function parser_chiffre(A, lettre=[])
    # fonction qui prend en argument les donnees et qui renvoit uniquement
    # donnees de type entier
    Donnees = []
    for i = 1:length(A)
        L = []
        for j = 1:length(A[i])
            if !(j in lettre)
                append!(L, parse(Int32, A[i][j]))
            end
        end
        append!(Donnees, [L])
    end
    return Donnees
end
