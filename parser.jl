function parser_import(file_path, hasheader=true, separator=';')
    i = 1 + hasheader
    open(file_path) do f
        content = readlines(f)
        parser = []
        for index in range(i, stop = length(content))
            append!(parser, [split(content[index], separator)])
        end
        return parser
    end
end

function parser_chiffre(A, list = [], lettre = [], type = Int32)
    # fonction qui prend en argument les donnees et qui renvoit uniquement
    # donnees de type entier
    Donnees = []
    for i = 1:length(A)
        L = Any[]
        for j = 1:length(A[i])
            if !(j in lettre)
                if (j in list)
                    l = split(A[i][j])
                    a = Any[]
                    for m = 1:length(l)
                        if (m == 1)
                            append!(a, parse(type, l[m][2:length(l[m])-1]))
                        else
                            append!(a, parse(type, l[m][1:length(l[m])-1]))
                        end
                    end
                    append!(L, [a])
                else
                    append!(L, parse(type, A[i][j]))
                end
            end
        end
        append!(Donnees, [L])
    end
    return Donnees
end
