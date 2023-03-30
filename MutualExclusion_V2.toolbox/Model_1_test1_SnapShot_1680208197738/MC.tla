---- MODULE MC ----
EXTENDS MutualExclusion_V2, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168020819560446000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_168020819560448000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:29:55 EDT 2023 by jorra04
