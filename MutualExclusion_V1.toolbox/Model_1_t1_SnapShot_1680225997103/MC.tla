---- MODULE MC ----
EXTENDS MutualExclusion_V1, TLC

\* CONSTANT definitions @modelParameterConstants:0Procs
const_16802259940486000 == 
{0,1}
----

\* PROPERTY definition @modelCorrectnessProperties:0
prop_16802259940488000 ==
\A i \in Procs : []<>(pc[i] = "cs")
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_16802259940489000 ==
\A i \in Procs : (pc[i] = "enter") ~> (pc[i] = "cs")
----
=============================================================================
\* Modification History
\* Created Thu Mar 30 21:26:34 EDT 2023 by jorra04
