include("parser.jl")
include("proba.jl")

nb_sommet = 4
nb_pas_tps = 3

function lecture_demande(Demande, nbpers, nbvols, proba, deb_class = 4, typepers = 2, place_demande = 3)
    demande_pers = zeros(nbvols)
    # Initialisation de demande_pers
    # demande_pers[i] représente le nombre de personnes prenant l'itinéraire i
    na = Int( nbpers / typepers )
    for i = 1:na
        for j = 1:length(Demande[i])-deb_class
            demande_pers[Demande[typepers*i-1][deb_class + j]] += proba[Demande[typepers*i-1][deb_class + j]]*Demande[typepers*i-1][place_demande]+proba[Demande[typepers*i-1][deb_class + j]+nbvols]*Demande[typepers*i][place_demande]
        end
    end
    return demande_pers
end

function gestion_cap(Itineraires, Demande, Capacites, proba, temps, leg_to_it)
    nbvols = length(Itineraires)
    leg = length(Capacites)
    nbpers = length(Demande)
    # Cette fonction vérifie que sur chaque leg, la capacité n'est pas dépassée
    # Si elle est dépassée, cette fonction enlève des personnes
    demande_pers = lecture_demande(Demande, nbpers, nbvols, proba)
    for i = 1:leg
        #dem représente la demande réelle du leg en question
        dem = 0
        for j in leg_to_it[i]
            dem += demande_pers[j]
        end
        if dem > Capacites[i]
            for j in leg_to_it[i]
                #Avec cette ligne on ramène la demande à la capacité du leg
                demande_pers[j] = demande_pers[j]*Capacites[i]/dem
            end
        end
    end
    return demande_pers
end

function gain(Itineraires, Demande, Capacites, proba, prix, temps, demande_pers)
    #demande_pers[i] représente le nombre de personnes prenant l'itinéraire i
    #et prix[i] le prix de cet itinéraire
    gain = sum(prix.*demande_pers)
    return gain
end
