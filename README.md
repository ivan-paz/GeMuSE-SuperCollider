
# SuperCollider implementation for Geometric Multi-parameter Space Exploration

This script is a SuperCollider implementation that, together with the Geometric Multi-parameter Space Exploration interface ( GeMuSE, located at: https://github.com/laliki/GeMuSe ) allows the perceptual exploration of the parameter space of an algorithmic system (in this case stored at Ndef(\x,{}) ).

Parameter space is understood as the set of all possible parameter combinations, of an algorithmic composition system, that determine the aural space created by the system.
By perceptual exploration I refer to the process of audition and subjective classification performed by the performer/composer/user by changing the parameter values of an algorithmic system.

During the exploration the user classify the combinations of parameters into perceptual classes. These could be, for example, outputs that can be used for different parts of a musical piece. Then, the parameter sets, together with the perceptual user evaluation, are considered as input/output relations. Such relations are processed, iteratively searching for regularities and thereby compressing the data to extract human readable and interpretable (if-then) rules able to represent musical entities of low and high-level. This process is carried out by the exploring-parameters algorithm (implemented in SuperCollider by Iván Paz and Julian Rohrhuber and available at https://github.com/musikinformatik/exploring-parameters ).
The exploring-parameters algorithm is used to compress the data into if-then rules that are used in a generative form throughout a simple Tdef.