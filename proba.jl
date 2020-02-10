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

function calcdonnee(L,C)
    F=[0.0 for i in 1:15]
    B=[0.0 for i in 1:15]
    Pfamille=[0.0 for i in 1:15]
    Pbusiness=[0.0 for i in 1:15]
    for j in 1:5
        f=0
        b=0
        for i in (3*(j-1)+1):(3*j)
            F[i]= exp(C[i] - 0.1*L[i])
            f+=exp(C[i] - 0.1*L[i])
            append!(B, exp(C[i] - 0.2*L[i]))
            b+=exp(C[i] - 0.2*L[i])
        end
        for p in (3*(j-1)+1):(3*j)
            Pfamille[p]=F[p]/f
            Pbusiness[p]=B[p]/f
        end
    end
    return append!(Pfamille,Pbusiness)
end

function probabilites(L0,C0,L1,C1,L2,C2)
    L=L0+L1+L2
    C=C0+C1+C2
    M0=calcdonnee(L0,C0)
    M1=calcdonnee(L1,C1)
    M2=calcdonnee(L2,C2)
    T=[M0,M1,M2]
    return T
end

probabili=probabilites(L0,C0,L1,C1,L2,C2)
