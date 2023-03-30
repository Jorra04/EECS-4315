---- MODULE MC ----
EXTENDS MutualExclusion_V1, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_168020935906378000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_168020935906380000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_168020935906381000 ==
\A i \in Procs : (pc[i] = "enter") ~> (pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:49:19 EDT 2023 by jorra04
