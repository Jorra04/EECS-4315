---- MODULE MC ----
EXTENDS MutualExclusion_V1, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168020771029234000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_168020771029236000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:21:50 EDT 2023 by jorra04
