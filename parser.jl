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

function parser_chiffre(A, lettre = [], type = Int32)
    # fonction qui prend en argument les donnees et qui renvoit uniquement
    # donnees de type entier
    Donnees = []
    i = 1
    while i <= length(A)
        L = []
        j = 1
        while j <= length(A[i])
            if !(j in lettre)
                if A[i][j] == "["
                    j += 1
                    l = []
                    while A[i][j] != "]"
                        append!(l, parse(type, A[i][j]))
                        j += 1
                    end
                    append!(L, [l])
                else
                    append!(L, parse(type, A[i][j]))
                end
            end
            j += 1
        end
        append!(Donnees, [L])
        i += 1
    end
    return Donnees
end
