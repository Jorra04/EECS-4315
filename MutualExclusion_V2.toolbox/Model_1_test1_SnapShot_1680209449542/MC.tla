---- MODULE MC ----
EXTENDS MutualExclusion_V2, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168020944749799000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_1680209447497101000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:50:47 EDT 2023 by jorra04
