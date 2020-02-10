include("parser.jl")
include("proba.jl")

nb_sommet = 4

function calcul_proba(itin,dem,cap)
    proba=
    return proba
end

function initialisation(itin,dem,cap)
    Itineraires = parser_import(itin)
    Demande = parser_import(dem)
    Capacites = parser_import(cap)
    nbvols=length(Itineraires)
    leg=length(Capacites)
    nbpers=length(Demande)
    proba=ones(nbvols)
    return (Itineraires, Demande,Capacites,nbvols,leg,nbpers,proba)
end

function ver_tuple_liste(l, a, b)
    #verifie si un tuple (a,b) et dans une liste
    n = length(l)
    for i in 1:(n-1)
        if (l[i]==a && l[i+1]==b)
            return true
        end
    end
    return false
end

function lecture_itin(Itineraires,nbvols,leg)
    #On remplit ici le tableau des prix ou prix[i] est le prix de l'itineraire i
    prix=zeros(nbvols)
    for i=1:nbvols
        prix[i]=parse(Int,Itineraires[i][7])
    end
    #Après cela, on construit leg_itin qui pour chaque leg (i,j), contient
    #tous les itinéraires qui contiennent ce leg
    leg_itin = []
    for i in 1:leg
        l=[]
        dep = Capacites[i][2]
        arr = Capacites[i][3]
        for j in 1:nbvols
            if ver_tuple_liste(Itineraires[j],dep,arr)
                append!(l,j)
            end
        end
        append!(leg_itin,[l])
    end
    return (prix,leg_itin)
end

function lecture_capa(Capacites,leg)
    #Initialisation des capacites
    cap = zeros(leg)
    for i = 1:leg
        cap[i] = parse(Int,Capacites[i][4])
        #cap[i] représente la capacité du leg i
    end
    return cap
end

function lecture_demande(Demande,nbpers,nbvols)
    demande_pers=zeros(nbvols)
    #Initialisation de demande_pers
    #demande_pers[i] représente le nombre de personnes prenant l'itinéraire i
    for i = 1:nbpers
        demande_pers[parse(Int,Demande[i][6])]+=0.4*parse(Int,Demande[i][4])
        demande_pers[parse(Int,Demande[i][7])]+=0.4*parse(Int,Demande[i][4])
    end
    return demande_pers
end

function gestion_cap(Itineraires, Demande,Capacites,nbvols,leg,nbpers)
    #Cette fonction vérifie que sur chaque leg, la capacité n'est pas dépassée
    #Si elle est dépassée, cette fonction enlève des personnes
    cap=lecture_capa(Capacites,leg)
    demande_pers=lecture_demande(Demande,nbpers,nbvols)
    demande_pers_init=copy(demande_pers)
    (prix,leg_itin)=lecture_itin(Itineraires,nbvols,leg)
    for i = 1:leg
        #dem représente la demande réelle du leg en question
        dem=0
        for j in leg_itin[i]
            dem+=demande_pers[j]
        end
        if dem>cap[i]
            for j in leg_itin[i]
                #Avec cette ligne on ramène la demande à la capacité du leg
                demande_pers[j]=demande_pers[j]*cap[i]/dem
            end
        end
    end
    return demande_pers
end


function gain(itin,dem,cap)
    proba=calcul_proba()
    (Itineraires, Demande,Capacites,nbvols,leg,nbpers)=initialisation(itin,dem,cap)
    demande_pers=gestion_cap(Itineraires,Demande,Capacites,nbvols,leg,nbpers)
    prix=lecture_itin(Itineraires,nbvols,leg)[1]
    #demande_pers[i] représente le nombre de personnes prenant l'itinéraire i
    #et prix[i] le prix de cet itinéraire
    gain=sum(prix.*demande_pers)
    return gain
end
