function localSearchAlgo_reduce(f, p_init, max_iter, bounds, radius, reduce_iter, reduce_frac; params=[false])
    """Local search for optimun with reduction of radius after reduce_iter
    iterations have failed to improve
    """
    # define whether to plot the results in 2D
    make_plot = params[1]
    # define the dimension of variables through initial point
    len = length(p_init)
    # if dimension is less than 2 warning for plotting
    if len < 1 & make_plot
        print("warning will not plot")
    end

    for dim = 1:len
        if bounds[dim][1] < p_init[dim] < bounds[dim][2]
            dummy=1
        else
            println("initial condition outside bounds")
            break
        end
    end

    # define initial evaluated function
    best_result = f(p_init)
    # define vector of all obj valiues
    all_results = zeros(max_iter)
    # define vector of all trials
    all_trials = zeros(len, max_iter)

    # -- main algorithm LS_reduce (start) -- #
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
            switch = 1
            for dim = 1:len
                if bounds[dim][1] < p_new[dim] < bounds[dim][2]
                    dummy=1
                else
                    switch = 0
                    break
                end
            end
            if switch == 1
              p_init = p_new
              best_result = test_result
              max_rep = 0
            end
        end
        max_rep += 1
        # compile list of all results for plotting
        all_trials[:,i] = p_new
        all_results[i] = test_result
        # iteration cap on same point
        if max_rep >= reduce_iter
            radius = radius * reduce_frac
            if max_rep >= 200
                println("max iter reached at "*string(i))
                break
          	end
        end

    end
    # -- main algorithm LS_reduce (end) -- #

    # plotting
    if make_plot
        scatter(all_trials[1,2:end], all_trials[2,2:end], c=all_results[2:end] , cmap="seismic")
        #plot(all_trials[1, :], all_trials[2, :], "o")#, p_new[2])
        show()
    end
    return p_init, best_result, radius
end
