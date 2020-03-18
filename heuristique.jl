include("parser.jl")
include("proba.jl")
include("tools.jl")
include("calcul_gain.jl")
include("calcul_gain_3pasdetemps.jl")

function heuristique_voisinage(nb_iter, Prix, Increase = 20, nbre_pas_tps = 3)
    Itineraires = parser_chiffre(parser_import("Itineraire_escales_prix_temps.csv"), [], [6,7])
    Capacites = lecture_capa(parser_import("Capacites2.csv"))
    leg_to_it, it_to_leg = separer_itineraire(Itineraires, 2, 4)
    Prix_max = [[0. for j in 1:length(Prix[i])] for i in 1:length(Prix)]
    egal_list(Prix_max, Prix)
    alpha = calc_alpha(Itineraires)
    Proba_max = []
    for i = 1:nbre_pas_tps
        P = calcdonnee(Prix_max[i], alpha)
        append!(Proba_max, [P])
    end
    for i = 1:nb_iter
        Proba = []
        for i = 1:nbre_pas_tps
            P = calcdonnee(Prix[i], alpha)
            append!(Proba, [P])
        end
        C = capacite_end(nbre_pas_tps, Itineraires, alpha, Proba, leg_to_it, it_to_leg)
        for j = 1:length(Capa)
            if (abs(C[j]) < 10^-10)
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
        Proba = []
        for i = 1:nbre_pas_tps
            P = calcdonnee(Prix[i], alpha)
            append!(Proba, [P])
        end
        println("Prix ", gain_total(Proba, Prix, Itineraires, leg_to_it, nbre_pas_tps))
        println("Prix max ", gain_total(Proba_max, Prix_max, Itineraires, leg_to_it, nbre_pas_tps))
        if gain_total(Proba, Prix, Itineraires, leg_to_it, nbre_pas_tps) > gain_total(Proba_max, Prix_max, Itineraires, leg_to_it, nbre_pas_tps)
            egal_list(Prix_max, Prix)
            egal_list(Proba_max, Proba)
        end
    end
    return Prix_max, Proba_max
end

function heuristique_voisinage2(nb_iter, Prix, Increase = 20, nbre_pas_tps = 3)
    Itineraires = parser_chiffre(parser_import("Itineraire_escales_prix_temps.csv"), [], [6,7])
    Capacites = lecture_capa(parser_import("Capacites2.csv"))
    leg_to_it, it_to_leg = separer_itineraire(Itineraires, 2, 4)
    Prix_max = [[0. for j in 1:length(Prix[i])] for i in 1:length(Prix)]
    egal_list(Prix_max, Prix)
    alpha = calc_alpha(Itineraires)
    Proba_max = []
    for i = 1:nbre_pas_tps
        P = calcdonnee(Prix_max[i], alpha)
        append!(Proba_max, [P])
    end
    for i = 1:nb_iter
        Proba = []
        for i = 1:nbre_pas_tps
            P = calcdonnee(Prix[i], alpha)
            append!(Proba, [P])
        end
        C, I = capacite_end_precis(nbre_pas_tps, Itineraires, alpha, Proba, leg_to_it, it_to_leg)
        for j = 1:length(Capacites)
            if (C[j] < 10^-10)
                for k in leg_to_it[j]
                    if !(k%nbre_pas_tps == 0)
                        Prix = Augmentation(Prix, Increase, k, I[j])
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
        Proba = []
        for i = 1:nbre_pas_tps
            P = calcdonnee(Prix[i], alpha)
            append!(Proba, [P])
        end

        println("Prix ", gain_total(Proba, Prix, Itineraires, leg_to_it, nbre_pas_tps))
        println("Prix max ", gain_total(Proba_max, Prix_max, Itineraires, leg_to_it, nbre_pas_tps))

        if gain_total(Proba, Prix, Itineraires, leg_to_it, nbre_pas_tps) > gain_total(Proba_max, Prix_max, Itineraires, leg_to_it, nbre_pas_tps)
            egal_list(Prix_max, Prix)
            egal_list(Proba_max, Proba)
        end
    end
    return Prix_max, Proba_max
end

function heuristique_voisinage3(nb_iter, Increase = 20, nbre_pas_tps = 3)
    OnD = parser_chiffre(parser_import("DataCreation/Data/little0/OnD.csv"), [6])
    flight = parser_chiffre(parser_import("DataCreation/Data/little0/flight.csv"), [5])
    itineraries = parser_chiffre(parser_import("DataCreation/Data/little0/itineraries.csv"), [5,7], [6])
    Capacites = lecture_capa(parser_import("DataCreation/Data/little0/flight.csv"))
    leg_to_it, it_to_leg = separer_itineraire_2(flight, itineraries)
    Prix = [[0. for j in 1:length(itineraries)] for i in 1:nbre_pas_tps]
    Prix_max = [[0. for j in 1:length(itineraries)] for i in 1:nbre_pas_tps]
    alpha = calculer_alpha(parser_import("DataCreation/Data/little0/itineraries.csv"))
    Proba_max = []
    for i = 1:nbre_pas_tps
        P = calcdonnee(Prix_max[i], alpha)
        append!(Proba_max, [P])
    end
    for i = 1:nb_iter
        Proba = []
        for j = 1:nbre_pas_tps
            P = calcdonnee(Prix[j], alpha)
            append!(Proba, [P])
        end
        C, I = capacite_end_precis_newFiles(nbre_pas_tps, itineraries, alpha, Proba, leg_to_it, it_to_leg)
        for j = 1:length(Capacites)
            if (C[j] < 10^-10)
                for k = 2:length(leg_to_it[j])
                    Prix = Augmentation(Prix, Increase, leg_to_it[j][k], I[j])
                end
            else
                for k = 2:length(leg_to_it[j])
                    if test_inf(Prix, Increase, k)
                        Prix = Diminution(Prix, Increase, leg_to_it[j][k], I[j])
                    end
                end
            end
        end
        Proba = []
        for j = 1:nbre_pas_tps
            P = calcdonnee(Prix[j], alpha)
            append!(Proba, [P])
        end

        if gain_total_newFiles(Proba, Prix, itineraries, leg_to_it, nbre_pas_tps) > gain_total_newFiles(Proba_max, Prix_max, itineraries, leg_to_it, nbre_pas_tps)
            egal_list(Prix_max, Prix)
            egal_list(Proba_max, Proba)
        end
    end
    return Prix_max, Proba_max
end

function heuristique_voisinage4(nb_iter, Prix, Proba, Increase = 20, nbre_pas_tps = 3)
    OnD = parser_chiffre(parser_import("DataCreation/Data/little0/OnD.csv"), [6])
    flight = parser_chiffre(parser_import("DataCreation/Data/little0/flight.csv"), [5])
    itineraries = parser_chiffre(parser_import("DataCreation/Data/little0/itineraries.csv"), [5,7], [6])
    Capacites = lecture_capa(parser_import("DataCreation/Data/little0/flight.csv"))
    leg_to_it, it_to_leg = separer_itineraire_2(flight, itineraries)
    Prix_max = [[0. for j in 1:length(itineraries)] for i in 1:nbre_pas_tps]
    egal_list(Prix_max, Prix)
    alpha = calculer_alpha(parser_import("DataCreation/Data/little0/itineraries.csv"))
    Proba_max = []
    for i = 1:nbre_pas_tps
        P = calcdonnee(Prix_max[i], alpha)
        append!(Proba_max, [P])
    end
    for i = 1:nb_iter
        Proba = []
        for j = 1:nbre_pas_tps
            P = calcdonnee(Prix[j], alpha)
            append!(Proba, [P])
        end
        C, I = capacite_end_precis_newFiles(nbre_pas_tps, itineraries, alpha, Proba, leg_to_it, it_to_leg)
        for j = 1:length(Capacites)
            if (C[j] < 10^-10)
                for k = 2:length(leg_to_it[j])
                    Prix = Augmentation(Prix, Increase, leg_to_it[j][k], I[j])
                end
            else
                for k = 2:length(leg_to_it[j])
                    if test_inf(Prix, Increase, k)
                        Prix = Diminution(Prix, Increase, leg_to_it[j][k], I[j])
                    end
                end
            end
        end
        Proba = []
        for j = 1:nbre_pas_tps
            P = calcdonnee(Prix[j], alpha)
            append!(Proba, [P])
        end

        if gain_total_newFiles(Proba, Prix, itineraries, leg_to_it, nbre_pas_tps) > gain_total_newFiles(Proba_max, Prix_max, itineraries, leg_to_it, nbre_pas_tps)
            egal_list(Prix_max, Prix)
            egal_list(Proba_max, Proba)
        end
    end
    return Prix_max, Proba_max
end

function heuristique_voisinage5(nb_iter, Prix, Proba, Increase = 20, nbre_pas_tps = 3)
    OnD = parser_chiffre(parser_import("DataCreation/Data/little0/OnD.csv"), [6])
    flight = parser_chiffre(parser_import("DataCreation/Data/little0/flight.csv"), [5])
    itineraries = parser_chiffre(parser_import("DataCreation/Data/little0/itineraries.csv"), [5,7], [6])
    Capacites = lecture_capa(parser_import("DataCreation/Data/little0/flight.csv"))
    leg_to_it, it_to_leg = separer_itineraire_2(flight, itineraries)
    Prix_max = [[0. for j in 1:length(itineraries)] for i in 1:nbre_pas_tps]
    egal_list(Prix_max, Prix)
    alpha = calculer_alpha(parser_import("DataCreation/Data/little0/itineraries.csv"))
    Proba_max = []
    for i = 1:nbre_pas_tps
        P = calcdonnee(Prix_max[i], alpha)
        append!(Proba_max, [P])
    end
    for i = 1:nb_iter
        Proba = []
        for j = 1:nbre_pas_tps
            P = calcdonnee(Prix[j], alpha)
            append!(Proba, [P])
        end
        C, Pers = capacite_end_newFiles(nbre_pas_tps, itineraries, alpha, Proba, leg_to_it, it_to_leg)
        for j = 1:length(Capacites)
            if (C[j] < 10^-10)
                for k = 2:length(leg_to_it[j])
                    for t = 1:nbre_pas_tps
                        Prix[t][leg_to_it[j][k]] += Increase*Pers[t][leg_to_it[j][k]]/Capacites[j]
                    end
                end
            else
                for k = 2:length(leg_to_it[j])
                    if test_inf(Prix, Increase, k)
                        Prix[t][leg_to_it[j][k]] += Increase*(1 - Pers[t][leg_to_it[j][k]]/(Capacites[j]-C[j]))
                    end
                end
            end
        end
        Proba = []
        for j = 1:nbre_pas_tps
            P = calcdonnee(Prix[j], alpha)
            append!(Proba, [P])
        end

        if gain_total_newFiles(Proba, Prix, itineraries, leg_to_it, nbre_pas_tps) > gain_total_newFiles(Proba_max, Prix_max, itineraries, leg_to_it, nbre_pas_tps)
            egal_list(Prix_max, Prix)
            egal_list(Proba_max, Proba)
        end
    end
    return Prix_max, Proba_max
end
