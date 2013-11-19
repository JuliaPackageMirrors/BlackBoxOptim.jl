module BlackBoxOptim

export  OptimizationProblem,

        Optimizer, PopulationOptimizer, 
        bboptimize, compare_optimizers,

        DiffEvoOpt, de_rand_1_bin, de_rand_1_bin_radiuslimited,

        AdaptConstantsDiffEvoOpt, adaptive_de_rand_1_bin, adaptive_de_rand_1_bin_radiuslimited,

        SeparableNESOpt, separable_nes,

        Problems,

        # Search spaces
        SearchSpace, FixedDimensionSearchSpace, ContinuousSearchSpace, 
        RangePerDimSearchSpace, symmetric_search_space,
        numdims, mins, maxs, deltas, ranges, range_for_dim,
        rand_individual, rand_individuals, isinspace, rand_individuals_lhs,

        hat_compare, isbetter, isworse, samefitness,
        popsize,
        FloatVectorFitness, float_vector_scheme_min, float_vector_scheme_max,
        FloatVectorPopulation

abstract Optimizer

module Utils
  include("utilities/latin_hypercube_sampling.jl")
end

include("fitness.jl")
include("population.jl")

abstract PopulationOptimizer <: Optimizer

population(o::PopulationOptimizer) = o.population # Fallback method if sub-types have not implemented it.

# Our design is inspired by the object-oriented, ask-and-tell "optimizer API 
# format" as proposed in:
#
#  Collette, Y., N. Hansen, G. Pujol, D. Salazar Aponte and 
#  R. Le Riche (2010). On Object-Oriented Programming of Optimizers - 
#  Examples in Scilab. In P. Breitkopf and R. F. Coelho, eds.: 
#  Multidisciplinary Design Optimization in Computational Mechanics, Wiley, 
#  pp. 527-565.
#  https://www.lri.fr/~hansen/collette2010Chap14.pdf
#
# but since Julia is not OO this is more reflected in certain patterns of how
# to specify and call optimizers. The basic ask-and-tell pattern is:
#
#   while !optimizer.stop
#     x = ask(optimizer)
#     y = f(x)
#     optimizer = tell(optimizer, x, y)
#   end
#
# after which the best solutions can be found by:
#
#   yopt, xopt = best(optimizer)
#
# We have extended this paradigm with the use of an archive that saves 
# information on what we have learnt about the search space as well as the
# best solutions found. For most multi-objective optimization problems there
# is no single optimum. Instead there are many pareto optimal solutions.
# An archive collects information about the pareto optimal set or some 
# approximation of it. Different archival strategies can be implemented.

include("search_space.jl")

# Different optimization algorithms
include("random_search.jl")
include("differential_evolution.jl")
include("adaptive_differential_evolution.jl")
include("natural_evolution_strategies.jl")

# Problems for testing
include(joinpath("problems", "all_problems.jl"))

# End-user/interface functions
include("bboptimize.jl")

end # module BlackBoxOptim