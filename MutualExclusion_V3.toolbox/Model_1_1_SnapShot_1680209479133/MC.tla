---- MODULE MC ----
EXTENDS MutualExclusion_V3, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_1680209477106105000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_1680209477106107000 ==
\A i \in Procs : (pc[i] = "enter") ~> (pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 16:51:17 EDT 2023 by jorra04
