include("parser.jl")
include("proba.jl")
include("FonctionRemplissage.jl")
include("calcul_gain.jl")

Capa = lecture_capa(parser_import("Capacites2.csv"))

function Augmentation(L, nbre, indice)
    for i = 1:length(L)
        L[i][indice] += nbre
    end
    return L
end

function Diminution(L, nbre, indice)
    for i = 1:length(L)
        L[i][indice] -= nbre
    end
    return L
end


function prix_ref(prix = 8, nb_pas_tps = 3)
    Donnees = parser_import("Itineraire_escales_prix_temps.csv")
    Prix = []
    for i = prix:nb_pas_tps + prix - 1
        L = []
        for j = 1:length(Donnees)
            append!(L, parse(Int32, Donnees[j][i]))
        end
        append!(Prix, [L])
    end
    return Prix
end

function prix_test(prix = 8)
    Donnees = parser_import("Itineraire_escales_prix_temps.csv")
    Prix = []
    for i = 1:length(Donnees)
        append!(Prix, [[parse(Float32, Donnees[i][prix])]])
    end
    return Prix
end

function test_inf(L, Increase, indice)
    for i in 1:length(L)
        if L[i][indice] < Increase
            return false
        end
    end
    return true
end

function egal_list(A, B)
    for i in 1:length(B)
        for j in 1:length(B[i])
            A[i][j] = B[i][j]
        end
    end
end

function capacite_end(nbre_pas_tps)
    C = lecture_capa(parser_import("Capacites2.csv"))
    for i in 1:nbre_pas_tps
        C = capacite_finale(C, i-1, Prix[i])
    end
    return C
end

function heuristique_voisinage(nb_iter, Prix, Increase = 20, nbre_pas_tps = 3)
    leg_to_it, it_to_leg = separer_itineraire(Itineraires, 2, 4)
    Prix_max = [[0. for j in 1:length(Prix[i])] for i in 1:length(Prix)]
    egal_list(Prix_max, Prix)
    truc, alpha = prix_alpha(Itineraires, 1)
    Proba_max = []
    for i = 1:nbre_pas_tps
        P = calcdonnee(Prix_max[i], alpha)
        append!(Proba_max, [P])
    end
    for i = 1:nb_iter
        C = capacite_end(nbre_pas_tps)
        Proba = []
        for i = 1:nbre_pas_tps
            P = calcdonnee(Prix[i], alpha)
            append!(Proba, [P])
        end
        for j = 1:length(Capa)
            if C[j] == 0
                for k in leg_to_it[j]
                    if !(k%nbre_pas_tps == 0)
                        Prix = Augmentation(Prix, Increase, k)
                    end
                end
            else
                for k in leg_to_it[j]
                    if test_inf(Prix, Increase, k)
                        Prix = Diminution(Prix, Increase, k)
                    end
                end
            end
        end
        if gain_total(Proba, Prix) > gain_total(Proba_max, Prix_max)
            egal_list(Prix_max, Prix)
            egal_list(Proba_max, Proba)
        end
    end
    return Prix_max, Proba_max
end
