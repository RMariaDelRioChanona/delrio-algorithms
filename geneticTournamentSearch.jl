# genetic algorithm
function geneticTournamentSearch(f, max_eval, n_wizards, bounds, mut_frac, mut_prob, duel_size, train_iter; params=[false])
    """
    Genetic algorithm, selection by tournament.Mut frac refers to how many particles are mutated from the offspring. 
    duel size is the number of particles that are compared in each tournament. 
    train iter is how many iterations are done between each sorting.
    Notice max_eval = n_wizards * max_iter. mut_prob is the probability of each dimension to mutate
    Note: here the crossover will always be more than the mutations, as we crossover and then mutate over
    these crossovers. We dumplicate the crossovers and then mutate some   
    """
    # define max_iter
    max_iter = max_eval/n_wizards
    if max_eval != n_wizards * max_iter
        println("max evaluation is not n_particles * max_iter")
    end
    # define whether to plot the results in 2D
    make_plot = params[1]
    # define the dimension of variables through initial point
    len = length(bounds)
    # if dimension is less than 2 warning for plotting
    if len < 1 & make_plot
        println("warning will not plot")
    end
    
    n_duels = convert(Int64, ceil(n_wizards/duel_size)) 
    #at most half of the replaces particles should be mutates
    #since after the tournament a "training" stage of mutation comes
    if (n_wizards - n_duels)/n_wizards < mut_frac * 2
        println("warning, too many mutations wrt cross-over")
    end
        
    #define array of all particles
    wizards = zeros((len, n_wizards))
    #define array with score of all particles
    score = zeros(n_wizards)
    #initialize particles and scores
    for wiz = 1:n_wizards
        wizards[:,wiz] = Float64[rand(Uniform(bounds[dim][1],bounds[dim][2])) for dim=1:len]
        score[wiz] = f(wizards[:, wiz])
    end
    # track evaluated particles
    all_trials = deepcopy(wizards)
    all_results = deepcopy(score)
    
    #initialize best particles
    winners = zeros((len, n_duels))
    # best_wizard and best_result must be defined for convenience
    best_wizard = wizards[:,1]
    best_result = f(wizards[:,1])
		# main algorithm (start)
    for iter = 1:max_iter
        #  ------------ shuffle ------------ #
        
        wizards = wizards[:,shuffle(1:end)]
        #a = a[shuffle(1:end), :]
        #  ------------ do tournament only every so interations ------------ #
        # tournament (begin)
        for duel = 1:(n_duels)
            # choose if end of list or not
            idx0 = convert(Int64, minimum([duel*duel_size, n_wizards]))
            # choose which particles will enter the tournamente this round
            idx1 = convert(Int64, (duel - 1) * duel_size + 1)
            wizards_in_duel = wizards[:, idx1:idx0]
            # select particle 1 to be the "best so far"
            # -------------------------- best_wizard =  wizards_in_duel[1]
            best_result = f(best_wizard)
            # tournament round
            for w = 2:n_wizards
                wiz = wizards[:, w]
                test_result = f(wiz)
                if test_result < best_result
                    best_wizard = copy(wiz)
                    best_result = test_result
                end
            end
                      
            winners[:, duel] = copy(best_wizard)
        end
        # tournament (end)
        #best particles are kept (survive)
        wizards[:, 1:n_duels] = deepcopy(winners)
        # here we re-evaluate the best particles as they are now the firsts in the list
        for k = 1:n_duels
             score[k] = f(wizards[:, k])
        end
        
        #reproduction (begin) 
        # here we just name the final index of the cross over for convenience
        max_crossover_ind = convert(Int64, floor((1 - mut_frac) * n_wizards))
        for new = (n_duels + 1):max_crossover_ind 
            # choose the first parent
            dad1_pos = rand(1:n_duels)
            dad2_pos = rand(1:n_duels)
            # make sure parent 1 and parent 2 are not the same
            while dad1_pos == dad2_pos
                dad2_pos = rand(1:n_duels)
            end
            # pure cross-over
            wizards[:, new] = [if rand(Uniform(0,1))<0.5 winners[gene,dad1_pos] else winners[gene,dad2_pos] end for gene=1:len]
            score[new] = f(wizards[:, new])
            # cross-over + mutation
            if new < (n_duels + 1) + (mut_frac) * n_wizards
                mutant_indx = new + max_crossover_ind - n_duels
                score[mutant_indx] = f(wizards[:, mutant_indx])
                wizards[:, mutant_indx] = [ if rand(Uniform(0,1)) < mut_prob rand(Uniform(bounds[gene][1], bounds[gene][2])) else wizards[gene, new] end for gene=1:len ]
            end            
        end
        #reproduction (end)
        
    		#concatenating results to plot. Note one is hcat other vcat.
    		all_trials = hcat(all_trials, wizards)
        all_results = vcat(all_results, score)
    end
    # main algorithm (end)


    # plotting
    if make_plot
        scatter(all_trials[1, :], all_trials[2, :], marker="o", c=all_results , cmap="seismic")
        show()
    end
    return best_wizard, best_result
end
