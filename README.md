
# SuperCollider script to perform parameter exploration together with the Geometric Multi-parameter Space Exploration interface "GeMuSE"

This script is a SuperCollider implementation that, together with the Geometric Multi-parameter Space Exploration interface ( GeMuSE, located at: https://github.com/laliki/GeMuSe ) allows the perceptual exploration of the parameter space of an algorithmic system capable of generating sound or musical material (in this case the system is stored at the Ndef( \x, {object} ) ).

Parameter space is understood as the set of all possible parameter combinations of the parametric system, that determine the aural space that it can create.

By perceptual exploration I refer to the process in which we (as composers or performers) tweak the system's parameters while listening to the changes of the output, until we find an interesting configuration. We can iteratively perform this process classifying the different outputs according, for example, to different functionalities. These could be, for example, outputs that can be used for different parts of a musical piece.

The algorithms presented here consider the parameter sets, together with the perceptual user evaluation, as input/output relations. Such relations are processed, iteratively searching for regularities and thereby compressing the data to extract human readable and interpretable (if-then) rules able to represent musical entities of low and high-level.

This process is carried out by the exploring-parameters algorithm (implemented in SuperCollider by Iván Paz and Julian Rohrhuber and available at https://github.com/musikinformatik/exploring-parameters ), and by its extension contained in rule\_extraction\_function.scd that allows to control the compression process by using thresholds.

Finally, the rules that are used in a generative form throughout a simple Tdef.

## Multi-threshold compression
The multi-threshold compression allows to define, for each parameter, different intervals with different thresholds for their values.
A threshold is the maximum distance between two parameter values for they to be placed (compressed) into a rule.

This functionality allow us to control the ammount of variation among the values contained in the rules, according to the established ranges for each parameter.

This is done with the gemuseSuperCollider\_multithreshold.scd script. In the following code, for hypotetical parameters 1 and 2, the compression thresholds are set as follows: For parameter 1 in the interval [0 to inf) the threshold is set to 1000. For parameter 2 in the interval [0,10] the threshold is set to 5, while in (10 to inf) the threshold has been set to 200. It is possible to define as many thresholds and intervals as we want.
```
~intervals_and_distances = [
      [

              [ [0, inf],  1000]

      ],

      [

              [ [0, 10], 5 ], [ [10, inf], 200 ]
      ]
])
```
For further documentation of the algorithms please contact me.
