include("parser.jl")
include("money.jl")

A = parser_import("Itineraire_escales_prix_temps.csv")
A1 = parser_chiffre(A,[6,7],Float64)


function prix_alpha(B,t)
    L=[]
    C=[]
    for i in 1:length(B)
        append!(L,B[i][6+t])
        append!(C,B[i][5])
    end
    return L,C
end

#liste des prix
#liste des alpha
L0,C0 = prix_alpha(A1,0)
L1,C1 = prix_alpha(A1,1)
L2,C2 = prix_alpha(A1,2)


#beta
beta1 = -1
beta2 = -2
#le temps est fixé a 1

function summ(L,C)
    a = 0
    for i in 1:length(C)
        a = a + exp(C[i] - 1 * L[i]) + exp(C[i] - 2 * L[i])
    end
    return a
end

function calc_t_donnee(L,C,S)
    M=[]
    for i in 1:length(C)
        append!(M, exp(C[i] - 1*L[i]) / S)
        append!(M, exp(C[i] - 2*L[i]) / S)
    end
    return M
end

function probabilites(L0,C0,L1,C1,L2,C2)
    T = []
    L=L0+L1+L2
    C=C0+C1+C2
    S=summ(L,C)
    M0=calc_t_donnee(L0,C0,S)
    M1=calc_t_donnee(L1,C1,S)
    M2=calc_t_donnee(L2,C2,S)
    append!(T,[M0])
    append!(T,[M1])
    append!(T,[M2])
    return T
end

a=probabilites(L0,C0,L1,C1,L2,C2)
