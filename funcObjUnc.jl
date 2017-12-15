module funcObjUnc
   #include("funcObjUnc.jl")
    f_x2(a) = sum(a'*a)

    # multidimensional x^2 objective function

    f_xy(a,b) = sum(a'*b + b'*a)
    export f_x2, f_xy
end
