# stochastic local search algorithm
function localSearchAlgo(f, p_init, max_iter, radius; params=[false])

    # define whether to plot the results in 2D
    make_plot = params[1]
    # define the dimension of variables through initial point
    len = length(p_init)
    # if dimension is less than 2 warning for plotting
    if len < 1 & make_plot
        print("warning will not plot")
    end

    # define initial evaluated function
    best_result = f(p_init)
    # define vector of all obj valiues
    all_results = zeros(max_iter)
    # define vector of all trials
    all_trials = zeros(len, max_iter)

    # -- main algorithm LS (start) -- #
    # must define dummy variables p_new
    p_new = 0
    max_rep = 0
    for i = 1:max_iter


        # define search radius
        r_rand = radius * [rand(Uniform(-1,1))for i=1:len]
        # define new trial point
        p_new = p_init + r_rand
        # obj value for trial point
        test_result = f(p_new)
        # test wether new point is better than best known
        if test_result < best_result
            p_init = p_new
            best_result = test_result
            max_rep = 0
        end
        max_rep += 1
        # compile list of all results for plotting
        all_trials[:,i] = p_new
        all_results[i] = test_result
        # iteration cap on same point
        if max_rep >= 100
            println("max iter reached at "*string(i))
            break
        end

    end
    # -- main algorithm LS (end) -- #

    # plotting
    if make_plot
        scatter(all_trials[1, :], all_trials[2, :], c=all_results , cmap="seismic")
        #plot(all_trials[1, :], all_trials[2, :], "o")#, p_new[2])
        show()
    end
    return p_init, best_result
end
