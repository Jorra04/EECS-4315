---- MODULE MC ----
EXTENDS MutualExclusion_V1, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168022628848116000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_168022628848118000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_168022628848119000 ==
\A i \in Procs : (pc[i] = "enter") ~> (pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 21:31:28 EDT 2023 by jorra04
