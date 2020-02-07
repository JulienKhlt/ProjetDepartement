function prix(prix = 9)
    Donnees = parser_import(Itineraire_escales_prix_temps.csv)
    P = []
    for i = 1:length(Donnees)
        append!(P, parse(Int32, Donnees[i][prix]))

function heuristique(nb_iter)
    for i = 1:nb_iter

end
