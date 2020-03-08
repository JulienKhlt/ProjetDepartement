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
            demande_pers[Demande[typepers*i-1][deb_class + j]] += proba[Demande[typepers*i-1][deb_class + j]]*Demande[typepers*i-1][place_demande]+proba[Demande[typepers*i-1][deb_class + j] + nbvols]*Demande[typepers*i][place_demande]
        end
    end
    return demande_pers
end

function lecture_demande_newFiles(Demande, Itineraires, proba, typepers = 2, place_demande_trav = 4, place_demande_fam=5, place_flight=7, place_itin=6)
    #Demande est un tableau correspondant au fichier OnD,
    #Itineraire est un tableau correspondant au fichier itineraries
    #proba donne un tableau avec autant de listes que de pas de temps; chaque liste donne la proba d'une famille pour les lignes impaires
    #et d'un travailleur pour les lignes paires
    nbitin=length(Itineraires)
    demande_pers = zeros(nbitin)
    # Initialisation de demande_pers
    # demande_pers[i] représente le nombre de personnes prenant l'itinéraire i : nb de personnes qui demandent x proba
    nbOD=length(Demande) #correspond au nb d'origines/destinations
    for i = 1:nbOD
        #i correspond au n° de l'origine-destination
        for j in Demande[i][place_itin]
            #j correspond à un itinéraire associé à l'origine/destination i
            demande_pers[j]+=proba[2*j-1]*Demande[i][place_demande_fam] + proba[2*j]*Demande[i][place_demande_fam]
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

function gestion_cap_newFiles(Itineraires, Demande, Capacites, proba, place_itin=5, place_capa=4)
    nbflights = length(Capacites)
    # Cette fonction vérifie que, sur chaque flight, la capacité n'est pas dépassée
    # Si elle est dépassée, cette fonction enlève des personnes
    demande_pers = lecture_demande_newFiles(Demande, Itineraires, proba)
    for i = 1:nbflights
        #i correspond à l'identifiant du vol
        dem=0
        #dem représente la demande réelle du vol en question
        for j in Capacites[i][place_itin]
            #j correspond à un identifiant d'itinéraire associé au vol i
            dem += demande_pers[j]
        end
        if dem > Capacites[i][place_capa]
            for j in Capacites[i][place_itin]
                #Avec cette ligne on ramène la demande à la capacité du vol
                demande_pers[j] = demande_pers[j]*Capacites[i][place_capa]/dem
            end
        end
    end
    return demande_pers
end

function gain(prix, demande_pers)
    #demande_pers[i] représente le nombre de personnes prenant l'itinéraire i
    #et prix[i] le prix de cet itinéraire
    gain = sum(prix.*demande_pers)
    return gain
end
