#import funcObjUnc

module funcObjUnc
	include("funcObjUnc.jl")
end

using funcObjUnc
using Distributions
using PyPlot

function localSearchAlgo(f, p_init, max_iter, radius, params = [False])

    # define whether to plot the results in 2D
    make_plot = params[1]
    # define the dimension of variables through initial point
    len = length(p_init)
    if len < 1 & make_plot
        print "warning will not plot"
    end
    # define initial evaluated function
    best_result = f(p_init)
    all_results = zeros(len)

    # main algorithm LS (start)
    for i = 1:max_iter

        r_rand = radius * Uniform(0,1)
        p_new = p_init + r_rand
        test_result = f(p_rand)
        if test_result	< best_result
            p_init = p_new
            best_result = test_result
        end
        # compile list of all results for plotting
        all_results[i] = test_result
    end
    # main algorithm LS (end)
    if make_plot
        scatter(p_new[1], p_new[2], c=all_results , cmap='seismic')
        show()
    end

    return p_new, best_result
end
