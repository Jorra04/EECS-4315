---- MODULE MC ----
EXTENDS MutualExclusion_V2, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168020942487286000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_168020942487288000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_168020942487289000 ==
\A i \in Procs : (pc[i] = "enter") ~> (pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:50:24 EDT 2023 by jorra04
