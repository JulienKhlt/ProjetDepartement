include("parser.jl")

A1 = parser_chiffre(parser_import("Itineraire_escales_prix_temps.csv"), [6,7])


function prix_alpha(B, t, prix = 6, alpha = 5)
    L = []
    C = []
    for i in 1:length(B)
        append!(L, B[i][prix + t])
        append!(C, B[i][alpha])
    end
    return L, C
end

#beta
beta1 = 0.1
beta2 = 0.2
#le temps est fixé a 1

function calcdonnee(L, C)
    Pfamille = [0.0 for i in 1:length(L)]
    Pbusiness = [0.0 for i in 1:length(L)]
    for j in 1:length(L)/3
        f = 0.0
        b = 0.0
        for k = (3*(j-1)+1):(3*j)
            i = round(Int, k)
            Pfamille[i] = exp(C[i] - beta1*L[i])
            f += exp(C[i] - beta1*L[i])
            Pbusiness[i] = exp(C[i] - beta2*L[i])
            b += exp(C[i] - beta2*L[i])
        end
        for k = (3*(j-1)+1):(3*j)
            p = round(Int, k)
            Pfamille[p] = Pfamille[p] / f
            Pbusiness[p] = Pbusiness[p] / b
        end
    end
    return append!(Pfamille, Pbusiness)
end

function probabilites(nb_pas_tps)
    T = []
    for i = 1:nb_pas_tps
        #liste des prix
        #liste des alpha
        L, C = prix_alpha(A1, i-1)
        M = calcdonnee(L, C)
        append!(T, [M])
    end
    return T
end

probabili = probabilites(3)
