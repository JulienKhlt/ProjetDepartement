#using parser

Itineraires = parser_import("Itineraire_escales_prix.csv")
Demande = parser_import("Demandes2.csv")
Capacites = parser_import("Capacites2.csv")

nbclasse = 2

nbvols = round(Int,length(Demande) / nbclasse)
itparvol = 3
leg = length(Capacites)
#En comptant le choix de ne pas acheter

prix = zeros(nbvols,itparvol)
proba = ones(nbvols,itparvol)

nb_sommet = 4

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

function lecture_itin(debut = 2, fin = 4)
    #Pour chaque leg j, itin_leg[i][j] vaut 1 si l'itinéraire i utlise le leg j
    n=length(Itineraires)
    itin_leg=[]

    for i=1:n
        l=[]
        for j=debut:fin
            if parse(Int,Itineraires[i][j])!=0
                append!(l,parse(Int,Itineraires[i][j]))
            end
        end
        append!(itin_leg,[l])
    end
    #Une fois ce tableau obtenu, on construit leg_itin qui pour chaque leg (i,j), contient
    #tous les itinéraires qui contiennent ce leg
    leg_itin = []
    for i in 1:leg
        l=[]
        dep = Capacites[i][2]
        arr = Capacites[i][3]
        for j in 1:nbvols
            if ver_tuple_liste(Itineraires[nbclasse*j], dep, arr)
                append!(l,j)
            end
        end
        append!(leg_itin,[l])
    end
    return leg_itin
end

function lecture_capa()
    #Initialisation des capacites
    cap = zeros(leg)
    for i = 1:leg
        cap[i] = parse(Int,Capacites[i][4])
        #cap[i] représente la capacité du leg i
    end
    return cap
end

function lecture_demande()
    demande_pers=zeros(nbvols,itparvol)
    #Initialisation de demande_pers
    #demande_pers[i][j] représente le nombre de personnes prenant l'itinéraire j du vol i
    for i = 1:nbvols
        for j = 1:itparvol
            demande_pers[i,j]=proba[i,j]*(parse(Int,Demande[2*i][4])+parse(Int,Demande[2*i-1][4]))
            #Demande[i][4] est la demande totale du vol i
            #parse sert à convertir en entier
        end
    end
    return demande_pers
end

function gestion_cap()
    cap = lecture_capa()
    demande_pers=lecture_demande()
    L = sum(demande_pers[:,2:itparvol], dims=2)
    #Cela donne un tableau où le i eme nombre est le
    #nombre de personnes empruntant l'itinéraire i
    return L
end


function gain()
    demande_pers=lecture_demande()
    #Initialisation de demande_pers
    #demande_pers[i][j] représente le nombre de personnes prenant l'itinéraire j du vol i
    gain=sum(prix.*demande_pers)
    return gain
end
