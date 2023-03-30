---- MODULE MC ----
EXTENDS MutualExclusion_V1, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168020875276766000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_168020875276769000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:39:12 EDT 2023 by jorra04
