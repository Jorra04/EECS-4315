---- MODULE MC ----
EXTENDS MutualExclusion_V2, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168020817161343000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_168020817161345000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:29:31 EDT 2023 by jorra04
