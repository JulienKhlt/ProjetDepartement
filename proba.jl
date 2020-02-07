A = parser_import("Itineraire_escales_prix_temps.csv")
B = parser_chiffre(A)



function prix_alpha(B,t)
    L=[]
    C=[]
    #beta=[]
    for i in 1:length(B)
        append!(L,B[i][6+t])
        append!(C,B[i][5])
        #append!(beta,B[i][])
    end
    return L,C
end
#C correspond à la liste des alpha
#L la liste des prix

#liste des prix
#liste des alpha
#liste des beta
L1,C1 = prix_alpha(B, 0)


#beta
beta1 =[ -1,-2]
#le temps est fixé a 1

function summ(C, beta, L, j)
    #j est egale à 0 si c'est une famille; 1 si c'est travailleur
    a = 0
    for i in 1:length(C)
        a = a + exp(C[i] + beta[j] * L[i])
    end
    return a
end

function probabilites(C, beta, L)

    U = []
    V = []
    for i in 1:length(C)
        append!(U, exp(C[i] + beta[1] * L[i] ) / summ(C,beta,L,0))
        append!(V, exp(C[i] + beta[1] * L[i] ) / summ(C,beta,L,1))
    end
    T=[]
    append!(T,U)
    append!(T,V)
    return T
end

probabilites(C1,beta1,L1)
