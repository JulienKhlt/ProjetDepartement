Itineraires = parser_import("Itineraire_escales_prix_temps.csv")
Demande0 = parser_chiffre(parser_import("DemandeT0.csv"))
Demande1 = parser_chiffre(parser_import("DemandeT1.csv"))
Demande2 = parser_chiffre(parser_import("DemandeT2.csv"))
Capacites = parser_chiffre(parser_import("Capacites2.csv"))

nbvols=length(Itineraires)
leg=length(Capacites)
nbpers=length(Demande)

proba=ones(nbvols)

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

function lecture_itin()

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
    return (leg_itin)
end


#l est la capacité à l'instant t
function capacité_finale(l,t)
    if t==0
        deman=Demande0
    elseif t==1
         deman=Demande1

    elseif t==2
        deman=Demande2
    end
    J = parser_import("Itineraire_escales_prix_temps.csv")
    itineraires = parser_chiffre(J)
    prix_a_t,alpha = prix_alpha(itineraires, t)
    P = calcdonnee(alpha,prix_a_t)
    OD_to_it = ODandIt(itineraires, deman)
    leg_to_it,it_to_leg,  = separer_itineraire(itineraires, 2, 4)
    nb_demande=[[0, 0] for i in 1:length(itineraires)]
    for id_OD in 1:length(deman)
        for id_itin in OD_to_it[id_OD]
            if deman[id_OD][4]==-2
                nb_demande[id_itin][1]=deman[id_OD][3]
            elseif deman[id_OD][4]==-1
                nb_demande[id_itin][2]=deman[id_OD][3]
            end
        end
    end
    for id_itin in 1:length(itineraires)
        for id_vol in 1:length(it_to_leg)
            l[id_vol]= max(l[id_vol]-(P[id_itin])*nb_demande[1][id_itin],0)
            l[id_vol]= max(l[id_vol]-(P[length(itineraires)+id_itin])*nb_demande[2][id_itin],0)
        end
    end
    return l
end
