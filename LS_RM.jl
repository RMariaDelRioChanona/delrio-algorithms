# stochastic local search Remus Lupin search
function LS_RM(f, max_iter, bounds, radius, reduce_iter, reduce_frac, RS_LS_split; params=[false])
    """
    RM = Remus Lupin
    This combines RS to find initial point, then uses LS where the search radius
    diminishes given a number of iteration withot improvement
    """

    # call RS algorithm to get good initial point
    point_RS, result_RS, trialsRS, resultsRS = randomSearchAlgo(f, convert(Int64, round(max_iter * RS_LS_split)), bounds; params=[false]);
    # from good starting point continue with local search
    point_LS, result_LS, radLS, trialsLS, resultsLS = localSearchAlgo_reduce(f,
        point_RS, convert(Int64, round(max_iter * (1-RS_LS_split))), bounds, radius, reduce_iter, reduce_frac; params=[false]);

    #concatenating results to plot. Note one is hcat other vcat.
    all_trials = hcat(trialsRS, trialsLS)
    all_results = vcat(resultsRS, resultsLS)

    # define whether to plot the results in 2D
    make_plot = params[1]
    # define the dimension of variables through initial point
    len = length(bounds)
    # if dimension is less than 2 warning for plotting
    if len < 1 & make_plot
        print("warning will not plot")
    end

    # plotting
    if make_plot
        scatter(all_trials[1, :], all_trials[2, :], marker=".", c=all_results , cmap="seismic")
        show()
    end
    return point_LS, result_LS, radLS
end
