include("parser.jl")

function prix_alpha(B, t, prix = 6, alpha = 5)
    L = []
    C = []
    for i in 1:length(B)
        append!(L, B[i][prix + t])
        append!(C, B[i][alpha])
    end
    return L, C
end

function calc_alpha(Itineraires, a = 5)
    A = []
    for i in 1:length(Itineraires)
        append!(A, Itineraires[i][a])
    end
    return A
end

#beta
beta1 = 0.008
beta2 = 0.014
#le temps est fixé a 1

function calcdonnee(L, C, nbre_pas_tps = 3)
    Pfamille = [0.0 for i in 1:length(L)]
    Pbusiness = [0.0 for i in 1:length(L)]
    for j in 1:length(L)/nbre_pas_tps
        f = 0.0
        b = 0.0
        for k = (nbre_pas_tps*(j-1)+1):(nbre_pas_tps*j)
            i = round(Int, k)
            Pfamille[i] = exp(C[i] - beta1*L[i])
            f += exp(C[i] - beta1*L[i])
            Pbusiness[i] = exp(C[i] - beta2*L[i])
            b += exp(C[i] - beta2*L[i])
        end
        for k = (nbre_pas_tps*(j-1)+1):(nbre_pas_tps*j)
            p = round(Int, k)
            Pfamille[p] = Pfamille[p] / f
            Pbusiness[p] = Pbusiness[p] / b
        end
    end
    return append!(Pfamille, Pbusiness)
end

function probabilites(nb_pas_tps, prix)
    T = []
    for i = 1:nb_pas_tps
        #liste des prix
        #liste des alpha
        L, C = prix_alpha(A1, i-1)
        M = calcdonnee(prix[i], C)
        append!(T, [M])
    end
    return T
end
