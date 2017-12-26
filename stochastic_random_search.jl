# stochastic random search
function randomSearchAlgo(f, max_iter, bounds; params=[false])

    # define whether to plot the results in 2D
    make_plot = params[1]
    # define the dimension of variables through initial point
    len = length(bounds)
    # if dimension is less than 2 warning for plotting
    if len < 1 & make_plot
        print("warning will not plot")
    end

    #define initial random particle
    p_best = Float64[rand(Uniform(bounds[j][1],bounds[j][2])) for j=1:len]
    # define initial evaluated function
    best_result = f(p_best)
    # define vector of all obj valiues
    all_results = zeros(max_iter)
    # define vector of all trials
    all_trials = zeros(len, max_iter)

    # -- main algorithm RS (start) -- #
    # must define dummy variables p_new
    p_new = 0
    max_rep = 0
    for i = 1:max_iter

        # define new random particle
        p_new = Float64[rand(Uniform(bounds[j][1],bounds[j][2])) for j=1:len] 
        # obj value for trial point
        test_result = f(p_new)
        # test wether new point is better than best known
        if test_result < best_result
            p_best = p_new
            best_result = test_result
            max_rep = 0
        end
        # compile list of all results for plotting
        all_trials[:,i] = p_new
        all_results[i] = test_result
        # iteration cap on same point
    end
    # -- main algorithm RS (end) -- #

    # plotting
    if make_plot
        scatter(all_trials[1, :], all_trials[2, :], marker=".", c=all_results , cmap="seismic")
        #plot(all_trials[1, :], all_trials[2, :], "o")#, p_new[2])
        show()
    end
    return p_best, best_result, all_trials, all_results
end
