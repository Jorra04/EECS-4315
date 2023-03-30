---- MODULE MC ----
EXTENDS MutualExclusion_V1, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168020870907062000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_168020870907165000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:38:29 EDT 2023 by jorra04
